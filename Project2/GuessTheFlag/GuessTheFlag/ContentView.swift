//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by EOCONE on 16/06/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var userScore = 0
    
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
                        self.flagTapped(number)
                    }) {
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
                            .shadow(color: .black, radius: 3)
                        
                    }
                    
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
            scoreTitle = "Correct!"
            userScore += 10
                
        } else {
            scoreTitle = "Alas, that's \(countries[number])'s flag"
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
