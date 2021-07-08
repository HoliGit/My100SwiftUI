//
//  ContentView.swift
//  iExpense
//
//  Created by SCOTTY on 06/07/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    var id = UUID() //generates automatically unique Ids for Identifiable protocol
    let name: String
    let type: String
    let amount: Int
}

class Expenses: ObservableObject {
    @Published var items: [ExpenseItem] {
        //en/decode can only archive obj that conform to Codable protocol
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    //to load again archived data when app relaunches, we need a custom initializer for Expenses class
    //first to read items key from UserDefault then create an instance of JSON decoder to return an array of expenses item objects
    init() {
        if let items = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            //try?...from:items tries to unarchive the Data obj into an array of ExpenseItem objs
            //[ExpenseItem] with .self to mean we are referring to the type object itself
            if let decoded = try? decoder.decode([ExpenseItem].self, from: items) {
                self.items = decoded
                return
            }
        }
        //if the above does not work, set items in an empty array
        self.items = []
    }
}

struct ContentView: View {
    //@observedobj checks changes in published properties and refresh the view
    @ObservedObject var expenses = Expenses()
    
    //tracks if AddView is being shown,must add .sheet(isPresented:) modifier to a view in contentview
    @State private var showingAddExpense = false

    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }

                        Spacer()
                        Text("$\(item.amount)")
                            .expenseStyle(for: item.amount)
                    }
                }
                .onDelete(perform: removeItems)
            }
            
            .navigationBarTitle("iExpense")
            
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                }
            )
            
            //challenge 1
            .toolbar {
                ToolbarItem(placement: .bottomBar){
                    EditButton()
                }
            }
            
            .sheet(isPresented: $showingAddExpense) {
                //connecting to AddView @observedobj var expenses
                AddView(expenses: self.expenses)
            }
            
            
            
        }
    }
    //adds the ability to remove items sliding, see ForEach
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

//challenge 2 amount colors

struct ExpenseStyle: ViewModifier {
    let amount: Int
    
    func body(content: Content) -> some View {
        switch self.amount {
            case Int.min ..< 15:
            return content
                .foregroundColor(.green)
            case 15 ..< 50:
            return content
                .foregroundColor(.orange)
            case 50 ... Int.max:
                return content
                    .foregroundColor(.red)
            default:
                return content
                    .foregroundColor(.black)
        }
    }
}

extension View {
    func expenseStyle(for amount: Int) -> some View {
        self.modifier(ExpenseStyle(amount: amount))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
