//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by EO on 19/07/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var orderWrapper = OrderWrapper()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $orderWrapper.order.type){
                        ForEach(0..<Order.types.count, id: \.self) {
                            Text(Order.types[$0])
                        }
                    }
                    
                    Stepper(value: $orderWrapper.order.quantity, in: 3...20){
                        Text("Number of cakes: \(orderWrapper.order.quantity)")
                         }
                    }
                
                Section {
                    Toggle(isOn: $orderWrapper.order.specialRequestEnabled.animation()){
                        Text("Any special request?")
                    }
                    
                    if orderWrapper.order.specialRequestEnabled {
                        Toggle(isOn: $orderWrapper.order.extraFrosting){
                            Text("Add extra frosting")
                        }
                        
                        Toggle(isOn: $orderWrapper.order.addSprinkles){
                            Text("Add extra sprinkles")
                        }
                        
                    }
                    
                }
                
                Section {
                    NavigationLink(destination: AddressView(orderWrapper: orderWrapper)) {
                        Text("Delivery details")
                    }
                }
            }
            
            .navigationBarTitle("CupcakeCorner")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
