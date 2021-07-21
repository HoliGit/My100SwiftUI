//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by EO on 19/07/21.
//

import SwiftUI

struct AddressView: View {
    @State var orderWrapper: OrderWrapper
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $orderWrapper.order.name)
                TextField("Street Address", text: $orderWrapper.order.streetAddress)
                TextField("City", text: $orderWrapper.order.city)
                TextField("Zip", text: $orderWrapper.order.zip)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(orderWrapper: orderWrapper)) {
                    Text("Check Out")
                }
            }
            
            .disabled(orderWrapper.order.hasValidAddress == false)
        }
        
        .navigationBarTitle("Delivery details", displayMode: .inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(orderWrapper: OrderWrapper())
    }
}
