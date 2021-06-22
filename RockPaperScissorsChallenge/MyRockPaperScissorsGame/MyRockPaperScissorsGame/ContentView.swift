//
//  ContentView.swift
//  MyRockPaperScissorsGame
//
//  Created by EO on 22/06/21.
//

import SwiftUI


struct ContentView: View {
    
    @State private var score = 0
    @State private var appChoices = Int.random(in: 0...2)
    @State private var playerShouldWin = Bool.random()
    @State private var turnCount = 1
    @State private var gameOver = false
    
    let moves = ["👊", "🖐", "✌️"]
    
    var body: some View {
        
         
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .center, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                
                
            VStack(spacing: 30) {
                Text("MY ROCKING APP")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(.yellow)
                .padding()
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .black, radius: 1)
                Text("My move is")
                Text("\(moves[appChoices])")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .shadow(color: .black, radius: 1)
                    
                    
                HStack {
                    Text("Try to")
                    Text("\(playerShouldWin ? "win" : "lose")")
                        .fontWeight(.bold)
                        .foregroundColor(playerShouldWin ? .green : .red)
                    Text("this turn")
                    
                }//end of Hstack
                
                Text("Choose your move")
                HStack(spacing: 30){
                    ForEach(moves, id: \.self){ playerMove in
                        Button(action: {
                            playerChooses(playerMove)
                        }) {
                            Text(playerMove)
                                .fontWeight(.bold)
                                .font(.largeTitle)
                                .padding()
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .shadow(color: .black, radius: 1)
                                .padding(.bottom)
                                
                        } //end of button text
                        
                    }//end of foreach
                    
                    
                }//end of Hstack2
                //Spacer(minLength: 20)
                
                VStack{
                    Text("Round \(turnCount) of 10")
                        .fontWeight(.bold)
                        .padding()
                        .font(.title)
                        
                    Text("SCORE: \(score)")
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.yellow)
                }
                .padding(20)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .black, radius: 1)
                
                
                
            }//end of Vstack
            
            .font(.largeTitle)
            .padding()
            
            
        }//end of zstack
        
        .edgesIgnoringSafeArea(.all)
        
        .alert(isPresented: $gameOver) {
            Alert(title: Text("Your score is: "), message: Text("\(score)"), dismissButton: .default(Text("Play again!")) {
                self.endGame()
            })
        }
        
    }//end of body
    
        

    
    
    func endGame() {
        score = 0
        turnCount = 0
        appChoices = Int.random(in: 0...2)
        playerShouldWin = Bool.random()
    }
    
    func nextTurn() {
        turnCount += 1
        if turnCount >= 10 {
            gameOver = true
        }
        appChoices = Int.random(in: 0...2)
        playerShouldWin = Bool.random()
    }
    
    func playerChooses(_ chosenMove: String){
        
        guard let playerChoice = moves.firstIndex(of: chosenMove) else { return }
        if playerShouldWin && (playerChoice == appChoices + 1 || playerChoice == appChoices - 2) {
            score += 10
            nextTurn()
        } else if !playerShouldWin && (playerChoice == appChoices - 1 || playerChoice == appChoices + 2) {
            score += 10
            nextTurn()
        } else {
            score -= 10
            nextTurn()
        }
    }
    
    
    
} //end of Content view


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
