//
//  AddView.swift
//  iExpense
//
//  Created by EO on 06/07/21.
//  Completed challenges on 08/07/21

import SwiftUI

struct AddView: View {
    
    //presentationMode links to isPresented bool called by dismiss(), see Save button below
    //no need to specify type thanks to @Environment property wrapper
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var expenses: Expenses //to share vith ContentView
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    
    @State private var showAmountError = false //challenge 3
    
    static let types = ["Business", "Personal"]
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            
            .navigationBarTitle("Add new expense")
            //adding new expense to the Expenses observable published array
            .navigationBarItems(trailing: Button("Save") {
                
                if let actualAmount = Int(self.amount) {
                    
                    let item = ExpenseItem(name: self.name, type: self.type, amount: actualAmount)
                    self.expenses.items.append(item)
                    //then close AddView
                    self.presentationMode.wrappedValue.dismiss()
                } else {
                    //challenge 3
                    self.showAmountError = true
                }
            })
            
            .alert(isPresented: self.$showAmountError) {
                Alert(title: Text("Invalid input"),
                      message: Text("Amount must be a number!"),
                      dismissButton: .default(Text("OK")))
            }
            //added extra button to exit sheet
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}

