//
//  ContentView.swift
//  WESPLIT
//
//  Created by Elena on 09/06/21.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    @State private var numberOfPeople = "" //changed from int to string
    @State private var tipPercentage = 2
    
    //add computed property to turn string to double - default 1 if no number entered
    var peopleCount: Double{
        (Double(numberOfPeople) ?? 1)
        }
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    var totalPerPerson: Double {
        //let peopleCount = Double(numberOfPeople + 2)
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        let amountPerPerson = grandTotal / peopleCount
        
        return amountPerPerson
        }
    
    var grandTotal: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        let tipValue = orderAmount / 100 * tipSelection
        let grandTotal = orderAmount + tipValue
        
        return grandTotal
        }
    
    
    var body: some View {
        NavigationView {
        
        Form {
            Section(header: Text("Insert the amount you want to split")) {
                TextField("Amount", text: $checkAmount)
                    .keyboardType(.decimalPad)
                }
                /*Picker ("Number of people", selection: $numberOfPeople){
                    ForEach(2..<100){
                        Text("\($0) people") }
                        }
                     } */
                //picker to textfield with number pad keyboard
            Section(header: Text("Insert the number of people")){
                TextField("Number of people", text: $numberOfPeople)
                    .keyboardType(.numberPad)
                }
                
            Section(header: Text("How much tip do you want to leave?")) {
                Picker("Tip percentage", selection: $tipPercentage){
                    ForEach(0..<tipPercentages.count){
                        Text("\(self.tipPercentages[$0])%")
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
            }
            
            Section(header: Text("Total check")) {
                Text("$\(grandTotal, specifier: "%2.f")")
                    }
            
            
            Section(header: Text("Total per person")) {
                Text("$\(totalPerPerson, specifier: "%.2f")")
                    }
            
        }
        .navigationBarTitle("WeSplit")
      }
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

