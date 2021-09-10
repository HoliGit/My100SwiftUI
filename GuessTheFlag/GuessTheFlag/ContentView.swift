//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by EOCONE on 16/06/21.
//  Challenges completed on 06/07/21
//

//Updated for Accessibility 

import SwiftUI

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
         content
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 3)
    }
}

extension View{
    func flagStyle() -> some View {
        self.modifier(FlagImage())
    }
}

struct ContentView: View {
    
    let labels = [
            "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
            "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
            "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
            "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
            "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
            "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
            "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
            "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
            "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
            "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
            "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
        ]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
    @State private var animationAmount = 0.0
    @State private var scaleAmount: CGFloat = 1
    
    @State private var wrongFlag = true
    
    @State private var animate = false
    
    var body: some View {
        
        ZStack {
            LinearGradient(gradient:
                            Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                
                VStack {
                    Text("Tap the flag of...")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text(countries[correctAnswer])
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        flagTapped(number)
                        
                        withAnimation {
                            self.animate = true
                            self.animationAmount += 360
                        }
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .flagStyle()
                            .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                        
                    }
                    .rotation3DEffect(.degrees(animationAmount), axis: (x: 0, y: (number == correctAnswer && !wrongFlag) ? 1 : 0, z: 0))
                    
                    .opacity(number != self.correctAnswer && self.animate ? 0.25 : 1.0 )
                    
                    .shadow(color: self.correctAnswer != number && self.animate ? .red : .clear, radius: 3)
                    
                    .overlay(self.correctAnswer != number && self.animate ? Capsule().stroke(Color.red, lineWidth: 3) : nil)
                    
                }
                
                VStack (spacing: 10){
                    Text("Your score is:")
                        .foregroundColor(.white)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .padding(.top, 20)
                    Text("\(userScore)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                    
                }
                
                Spacer()
            }
            
        }
        
        .alert(isPresented: $showingScore){
            Alert(title: Text(scoreTitle), message: Text("Your score is \(userScore)"), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
        
    }
    
    func flagTapped(_ number: Int){
        
        if number == correctAnswer {
            wrongFlag = false
            scoreTitle = "Correct!"
            userScore += 10
            
            
        } else {
            scoreTitle = "Alas, that's \(countries[number])'s flag"
            wrongFlag = true
            
        }
        showingScore = true
    }
    
    
    func askQuestion() {
        animate = false
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

