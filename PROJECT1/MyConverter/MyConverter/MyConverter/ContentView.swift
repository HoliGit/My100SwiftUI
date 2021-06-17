//
//  ContentView.swift
//  MyConverter
//
//  Created by Elena on 14/06/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var inputAmount = ""
    @State private var startUnit = 0
    @State private var endUnit = 1
    
    @State private var inputWeight = ""
    @State private var startWeight = 0
    @State private var endWeight = 1
    
    
    
    let units: [UnitLength] = [.meters, .kilometers, .yards, .miles, .fathoms]
    
    let weights: [UnitMass] = [.grams, .kilograms, .pounds, .ounces, .slugs]
    
    private var convertedValue: Double {
        let unitToConvert = Measurement(value: Double(inputAmount) ?? 0, unit: units[startUnit])
        return unitToConvert.converted(to: units[endUnit]).value
    }
    
    private var convertedWeight: Double {
        let weightToConvert = Measurement(value: Double(inputWeight) ?? 0, unit: weights[startWeight])
        return weightToConvert.converted(to: weights[endWeight]).value
    }

    
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("CONVERT LENGTHS OR WEIGHTS UNFATHOMABLY AND WITHOUT SLUGGINESH")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.purple)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, -1.0)){
                    Text("FATHOM YOUR LENGTHS")
                }
            
                Section(header: Text("Input for Length")){
                    TextField("Enter amount:", text: $inputAmount)
                        .keyboardType(.decimalPad)
                    Picker("Starting unit", selection: $startUnit){
                        ForEach(0..<units.count) {
                            Text(verbatim: self.units[$0].symbol)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Output for Lenght")) {
                    Picker("End unit", selection: $endUnit){
                        ForEach(0..<units.count) {
                            Text(verbatim: self.units[$0].symbol)
                        }
                    }
                    
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("\(convertedValue, specifier: "%.4g")")
                }
             
                Section(){
                    Text("WEIGHT YOUR SLUGS")
                }
                
                Section(header: Text("Input for Weight")){
                    TextField("Enter amount:", text: $inputWeight)
                        .keyboardType(.decimalPad)
                    Picker("Starting unit", selection: $startWeight){
                        ForEach(0..<weights.count) {
                            Text(verbatim: self.weights[$0].symbol)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Output for Weight")) {
                    Picker("End unit", selection: $endWeight){
                        ForEach(0..<weights.count) {
                            Text(verbatim: self.weights[$0].symbol)
                        }
                    }
                    
                    .pickerStyle(SegmentedPickerStyle())
                    
                    Text("\(convertedWeight, specifier: "%.4g")")
                }
                
                
            }
            
            .navigationBarTitle("FATHOMS & SLUGS")
            .navigationBarTitleDisplayMode(.inline)
            
        
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
