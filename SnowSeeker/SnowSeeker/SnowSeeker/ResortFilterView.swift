//
//  ResortFilterView.swift
//  SnowSeeker
//
//  Created by EO on 06/10/21.
//

import SwiftUI

struct ResortFilterView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var filter: Filter
    
    let countries: [String]
    let possiblePrices = ["All", "$", "$$"]
    let possibleResortSizes = ["All", "Small", "Medium", "Large"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("").accessibility(hidden: true)) {
                    Picker("Country", selection: $filter.selectedCountry) {
                        ForEach(countries, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
                
                Section(header: Text("").accessibility(hidden: true)) {
                    VStack(alignment: .leading) {
                        Text("Price")
                        Picker("", selection: $filter.selectedPrice) {
                            ForEach(0 ..< possiblePrices.count) {
                                Text("\(self.possiblePrices[$0])")
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
                
                Section(header: Text("").accessibility(hidden: true)) {
                    VStack(alignment: .leading) {
                        Text("Resort size")
                        Picker("", selection: $filter.selectedResortSize) {
                            ForEach(0 ..< possibleResortSizes.count) {
                                Text("\(self.possibleResortSizes[$0])")
                            }
                        }
                        
                        .pickerStyle(SegmentedPickerStyle())
                    }
                }
            }
            
            .navigationBarTitle("Resorts filter")
            .navigationBarItems(trailing: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Done")
                    .bold()
            })
        }
    }
}

struct ResortFilterView_Previews: PreviewProvider {
    static var previews: some View {
        ResortFilterView(filter: .constant(Filter()), countries: ["France", "Italy"])
    }
}
