//
//  ContentView.swift
//  Animations
//
//  Created by EO on 29/06/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animationAmount: CGFloat = 1
    
    var body: some View {
        
        VStack {
            
        Button("Tap me"){
            self.animationAmount += 1
        }
        
        .buttonStyle(BorderlessButtonStyle())
        .padding(50.0)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .scaleEffect(animationAmount)
        //.blur(radius: (animationAmount - 1) * 3)
        //animation() applies to any change that happens to the view
        //.default = easein, easeout
        //.easeOut start fast end slow
        //we can add duration : .animation(.easeInOut(duration: 2))
        // spring animations:  .animation(.interpolatingSpring(stiffness: 50, damping: 1))
        //or we can specify more
        .animation(
            Animation.easeInOut(duration: 2)
                //.delay(1)
                //.repeatCount(3, autoreverses: true)
                //.repeatForever(autoreverses: true)
                )
        .padding(.bottom)
        
        
        Spacer()
            .frame(height: 110)
        
            
        Button("Tap me"){
            print("I am tapped")
        }
        .padding(50)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay(Circle()
                    .stroke(Color.blue)
                    .scaleEffect(animationAmount)
                    .opacity(Double(2 - animationAmount))
                    .animation(Animation.easeInOut(duration: 1)
                    .repeatForever(autoreverses: false)
                    )
                 )
        
        //.onAppear {
            //self.animationAmount = 2 }
          
        }
        
        .buttonStyle(BorderlessButtonStyle())
    
   }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
