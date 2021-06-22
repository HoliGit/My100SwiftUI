//
//  ContentView.swift
//  ViewsAndModifiers
//
//  Created by SCOTTY on 17/06/21.
//

import SwiftUI

struct CapsuleText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.light)
            .shadow(color: .black, radius: 1)
            .padding()
            //.foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
            .shadow(color: .black, radius: 1)
    }
}


struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            //.foregroundColor(.white)
            .padding()
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}

extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
}


struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing){
            content
            Text(text)
                .font(.caption2)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
        }
    }
}

extension View {
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
}


struct ContentView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.yellow, Color.red]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            
            VStack{
                
                HStack{
                    Text("VIEWS & MODS")
                        .titleStyle()
                        .foregroundColor(.orange)
                    
                    Image(systemName: "pencil")
                        .imageScale(.large)
                        .foregroundColor(.black)
                        .shadow(color: .white, radius: 20)
                        .padding(21)
                        //.background(Color.black)
                        
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.black, lineWidth: 2))
                        //.shadow(color: .black, radius: 5)
                    
                }
                
                Button(action: {
                    print("You Tapped me!")
                }) {
                     Text("TAP ME!")
                        .foregroundColor(.black)
                        .fontWeight(.black)
                        //.shadow(color: .black, radius: 1)
                        .padding(36)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: .purple, radius: 15)
                        
                        .frame(maxWidth: 250, maxHeight: 250)
                        .background(Color.red)
                        .watermarked(with: "MyWatermark")
                        .padding()
                        .background(Color.green)
                        .padding(30)
                        .background(Color.purple)
                        .shadow(color: .black, radius: 5)
                }
                
                CapsuleText(text: "Capsule Text")
                    .foregroundColor(.white)
                
                Text("My Blue Title Style")
                    .titleStyle()
                    .foregroundColor(.blue)
                
            }
        }
    }
    
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
}
