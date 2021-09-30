//
//  ContentView.swift
//  Flashzilla
//
//  Created by EO on 28/09/21.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}

enum UserDefaultsKeys: String {
    case RetryWrongAnswers, Cards
}

struct ContentView: View {
    
    enum SheetType {
        case settings
        case editCards
    }
    
    static let timeAllowed = 100
    
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    
    @State private var cards = [Card]()
    
    @State private var isActive = false
    
    @State private var timeRemaining = timeAllowed
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State private var showingSheet = false
    @State private var sheetType: SheetType = .settings
    
    @State private var retryWrongAnswers = UserDefaults.standard.bool(forKey: UserDefaultsKeys.RetryWrongAnswers.rawValue)
    
    @State private var feedback = UINotificationFeedbackGenerator()
    @State private var hapticManager: HapticManager?
    
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image(decorative: "background")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: geometry.size.width)
            }
            
            VStack {
                if timeRemaining > 0 {
                    
                    Text("Time: \(timeRemaining)")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.black)
                                .opacity(0.75))
                        .padding(.top, 30)
                    
                    ZStack{
                        ForEach(0..<cards.count, id: \.self) { index in
                            CardView(card: self.cards[index]) { isCorrect in
                                
                                withAnimation {
                                    self.removeCard(at: index, isCorrect: isCorrect)
                                }
                            }
                            .stacked(at: index, in: self.cards.count)
                            //only the top card can be dragged, and read by voiceover
                            .allowsHitTesting(index == self.cards.count - 1)
                            .accessibility(hidden: index < self.cards.count - 1)
                        }
                    }
                    
                    //when time finish, disable view interactivity
                    .allowsHitTesting(timeRemaining > 0)
                    
                } else {
                    
                    Text("Time's up!")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 5)
                        .background(Capsule()
                                        .fill(Color.red)
                                        .opacity(0.75)
                        )
                }
                
                if cards.isEmpty || timeRemaining == 0 {
                    Button("Start again", action: resetCards)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                
            }
            
            VStack {
                
                HStack {
                    
                    Button(action: {
                        self.sheetType = .settings
                        self.showingSheet = true
                        
                    }) {
                        Image(systemName: "gear")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.sheetType = .editCards
                        self.showingSheet = true
                        
                    }) {
                        Image(systemName: "plus.circle")
                            .padding()
                            .background(Color.black.opacity(0.7))
                            .clipShape(Circle())
                    }
                    
                    .padding()
                }
                
                Spacer()
            }
            
            .foregroundColor(.white)
            .font(.largeTitle)
            .padding()
            
            
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            withAnimation {
                                self.removeCard(at:
                                                    self.cards.count - 1, isCorrect: false)
                            }
                        }) {
                            Image(systemName: "xmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect"))
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                self.removeCard(at:
                                                    self.cards.count - 1, isCorrect: true)
                            }
                        }) {
                            Image(systemName: "checkmark.circle")
                                .padding()
                                .background(Color.black.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct"))
                        
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        
        .onReceive(timer) { time in
            guard self.isActive else { return }
            hapticManager = HapticManager()
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                //challenge 1
                if self.timeRemaining == 2 {
                    self.hapticManager?.prepare()
                }
                
                if self.timeRemaining == 0 {
                    self.hapticManager?.customHapticPattern()
                    print("Playing slice")
                }
                
            }
            
        }
        
        //pause timer if app in the background
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        
        //resume timer when app is back
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            
            if self.cards.isEmpty == false {
                self.isActive = true
            }
        }
        
        .sheet(isPresented: $showingSheet, onDismiss: resetCards){
            switch sheetType {
                case .settings:
                    SettingsView(retryWrongAnswers: $retryWrongAnswers)
                case .editCards:
                    EditCards()
            }
        }
        
        .onAppear(perform: resetCards)
        
    }
    
    func removeCard(at index: Int, isCorrect: Bool) {
        guard index >= 0 else { return }
        
        let removedCard = cards.remove(at: index)
        if !isCorrect && retryWrongAnswers {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                cards.insert(removedCard, at: 0)
            }
        }
        
        if cards.isEmpty {
            isActive = false
            self.feedback.notificationOccurred(.success)
        }
    }
    
    func resetCards() {
        timeRemaining = Self.timeAllowed
        loadData()
        if !cards.isEmpty {
            isActive = true
        }
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsKeys.Cards.rawValue) {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
