//
//  ContentView.swift
//  WordScramble
//
//  Created by EO on 28/06/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    
    private var score: Int {
        var myScore = 0
        for word in usedWords {
            myScore += word.count
        }
        return myScore
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                Text("Make as many words you can out of these 8 characters - no cheating!")
                    .padding()
                    .background(Color.init(red: 233/255, green: 195/255, blue: 240/255))
                
                Text("\(rootWord)")
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .shadow(color: .black, radius: 0.5)
                
                
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                //create a row for each word in the array
                //uniquely identified by the word itself
                //and placed at the top position 0
                
                //Edited for accessibility: create explicit Hstack for VoiceOver
                
                /*List(usedWords, id: \.self) {
                    Image(systemName: "\($0.count).circle")
                    Text($0)
                }*/
                
                List(usedWords, id\.self) {
                    HStack{
                       Image(sistemName: "\(word.count).circle")
                        Text(word)
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibility(label: Text("\(word), \(word.count) letters"))
                }
                
                Text("SCORE: \(score)")
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                    .shadow(color: .black, radius: 0.5)
                
            
            }
            
            .navigationBarTitle("WORD SCRAMBLE")
            .padding()
            .navigationBarItems(trailing: Button(action: startGame) {
                Text("Start new game")
                    .padding(.bottom, 15.0)
                    .shadow(color: .black, radius: 0.5)
            })
            
            .onAppear(perform: startGame)
            .alert(isPresented: $showingError){
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        guard answer.count > 2 else {
            wordError(title: "Word too short", message: "Words should be at least 3 characters long")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "Same as rootword", message: "This is not allowed")
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func startGame() {
        //cleanup before new game
        usedWords.removeAll()
        
        //find the url for file in bundle
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            
            //load txt file in a string
            if let startWords = try? String(contentsOf: startWordsURL) {
                
                //split string in array of strings
                //"\n" splits on line breaks
                let allWords = startWords.components(separatedBy: "\n")
                //pick a random word or use silkworm as default
                rootWord = allWords.randomElement() ?? "silkworm"
                
                //if everything worked, exit
                return
            }
        }
        //otherwise trigger a crash and report error
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String){
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
