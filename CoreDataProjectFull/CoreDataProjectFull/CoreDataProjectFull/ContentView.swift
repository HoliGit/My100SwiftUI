//
//  ContentView.swift
//  CoreDataProjectFull
//
//  Created by SCOTTY on 25/08/21.
//

import CoreData
import SwiftUI

enum FilterType: String, CaseIterable {
    case equals = "=="
    case beginsWith = "BEGINSWITH"
    case not = "NOT"
}

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Country.entity(), sortDescriptors: [], predicate: nil) var countries: FetchedResults<Country>
    
    @State private var countryNameFilter = ""
    @State private var filterType = FilterType.equals
    
    var body: some View {
        NavigationView {
            VStack {
                FilteredList(filterKey: "fullName", filterValue: countryNameFilter, filterType: filterType, sortBy: [NSSortDescriptor(key: "fullName", ascending: true)]) { (country: Country) in
                    
                    Section(header: Text("\(country.wrappedFullName) \(country.wrappedShortName)")) {
                        
                        ForEach(country.teaArray, id: \.self) { tea in
                            Text(tea.wrappedName)
                        }
                        .onDelete(perform:{ offsets in
                            self.deleteTeas(at: offsets, from: country)
                            
                        })
                        
                    }
                    
                }
                
                Section(header: Text("Filter country by")){
                    Picker("Predicate type", selection: $filterType) {
                        ForEach(FilterType.allCases, id: \.self) { item in
                            Text(item.rawValue)
                        }
                    } .pickerStyle(SegmentedPickerStyle())
                    
                    
                 
                    HStack {
                        Text(filterType.rawValue)
                        TextField("Add filter string...", text: $countryNameFilter)
                    }
                    .padding([.leading, .trailing])
                    
                }
                .padding([.leading, .trailing])
                
                
                /*Button("Show A") {
                    self.countryNameFilter = "A"
                }*/
                
                Button("Show all") {
                    self.countryNameFilter = ""
                }
                
                Button("Add") {
                    let tea1 = Tea(context: self.moc)
                    tea1.name = "Earl Gray"
                    tea1.origin = Country(context: self.moc)
                    tea1.origin?.fullName = "United Kingdom"
                    tea1.origin?.shortName = "UK"
                    
                    let tea2 = Tea(context: self.moc)
                    tea2.name = "Oolong"
                    tea2.origin = Country(context: self.moc)
                    tea2.origin?.fullName = "China"
                    tea2.origin?.shortName = "CN"
                    
                    let tea3 = Tea(context: self.moc)
                    tea3.name = "Chay"
                    tea3.origin = Country(context: self.moc)
                    tea3.origin?.fullName = "India"
                    tea3.origin?.shortName = "IN"
                    
                    let tea4 = Tea(context: self.moc)
                    tea4.name = "Matcha"
                    tea4.origin = Country(context: self.moc)
                    tea4.origin?.fullName = "Japan"
                    tea4.origin?.shortName = "JP"
                    
                    let tea5 = Tea(context: self.moc)
                    tea5.name = "Jasmine"
                    tea5.origin = Country(context: self.moc)
                    tea5.origin?.fullName = "China"
                    tea5.origin?.shortName = "CN"
                    
                    let tea6 = Tea(context: self.moc)
                    tea6.name = "Cha Yen"
                    tea6.origin = Country(context: self.moc)
                    tea6.origin?.fullName = "Thailand"
                    tea6.origin?.shortName = "TH"
                    
                }
                
                Button("Save") {
                    if self.moc.hasChanges {
                        do {
                            try self.moc.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                }
                
            }
            
            .navigationBarTitle("World of Teas")
            
            .toolbar {
                EditButton()
            }
            
        }
        
    }
    
    func deleteTeas(at offsets: IndexSet, from country: Country){
        for offset in offsets.sorted().reversed() {
            let teaToDelete = country.teaArray[offset]
            country.removeFromTea(teaToDelete)
            moc.delete(teaToDelete)
        }
        
        if moc.hasChanges{
            try? moc.save()
        }
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
