//
//  ContentView.swift
//  Drawing
//
//  Created by EO on 12/07/21.
//

import SwiftUI

//challenge 3 
struct ColorCyclingRectangle: View{
    
    var amount = 0.0
    var steps = 50
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    //.strokeBorder(self.color(for: value, brightness: 1), lineWidth: 2)
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [
                        self.color(for: value, brightness: 1),
                        self.color(for: value, brightness: 0.5)
                    ]), startPoint: .top, endPoint: .bottom), lineWidth: 2)
            }
        }
        //use .drawingGroup() only if you need more performance
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}

//challenge 1 draw an arrow
struct ArrowShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addRect(CGRect(x: rect.maxX / 4, y: rect.midY, width: rect.maxX / 2 , height: rect.maxY / 2))
        
        return path
    }
}

struct ContentView: View {
    @State private var lineThickness: CGFloat = 1
    @State private var showMessage = true
    
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            Text(showMessage ? "TAP THE ARROW!" : "")
                .font(.largeTitle)
                .foregroundColor(.blue)
                .shadow(color: .orange, radius: 3, x: 1.0, y: 1.0)
            
            ArrowShape()
                
                .stroke(Color.blue, style: StrokeStyle(lineWidth: lineThickness, lineCap: .round, lineJoin: .round))
                .overlay(ArrowShape().foregroundColor(.orange))
                .frame(width: 150 , height: 200)
                
                //Challenge 2 animate the arrow border
                .onTapGesture {
                    withAnimation(.interpolatingSpring(stiffness: 50, damping: 2)){
                        self.lineThickness = 30
                        self.showMessage = false
                    }
                }
                .padding(.bottom, 50.0)
            
            Text("SLIDE THE RAINBOW!")
                .font(.largeTitle)
                .foregroundColor(.orange)
                .shadow(color: .blue, radius: 3, x: 1.0, y: 1.0)
            
            ColorCyclingRectangle(amount: self.colorCycle)
                .frame(width: 300, height: 150)
            
            Slider(value: $colorCycle)
                .padding()
            
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
