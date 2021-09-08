//
//  CheckoutView.swift
//  CupcakeCorner
//
//  Created by EO on 19/07/21.
//

import SwiftUI

struct CheckoutView: View {
    @ObservedObject var orderWrapper: OrderWrapper
    
    @State private var confirmationMessage = ""
    @State private var showingConfirmation = false
    
    //challenge 2, so that we can have different titles and message for one alert
    @State private var alertTitle = ""
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image(decorative: "cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.orderWrapper.order.cost, specifier: "%.2f")")
                        .font(.title)
                    
                    Button("Place order"){
                        self.placeOrder()
                    }
                    .padding()
                }
            }
            
        }
        .navigationBarTitle("Check out", displayMode: .inline)
        .alert(isPresented: $showingConfirmation){
            Alert(title: Text(alertTitle), message: Text(confirmationMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func placeOrder() {
        
        guard let encoded = try? JSONEncoder().encode(orderWrapper.order)
        else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) {
            data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error").")
                self.alertTitle = "Something went wrong"
                self.showingConfirmation = true
                self.confirmationMessage = "Your order could not be placed, try checking your internet connection"
                
                return
            }
            
            if let decodedOrder = try?
                JSONDecoder().decode(Order.self, from: data){
                self.confirmationMessage = "Your order for \(decodedOrder.quantity)x \(Order.types [decodedOrder.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
                self.alertTitle = "Thank you!"
            } else {
                print("Invalid response from server")
            }
            
        }.resume()
        
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(orderWrapper: OrderWrapper())
    }
}
