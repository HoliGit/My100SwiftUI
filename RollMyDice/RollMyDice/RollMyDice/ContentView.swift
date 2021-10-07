//
//  ContentView.swift
//  RollMyDice
//
//  Created by EO on 05/10/21.
//

import SwiftUI
import CoreData
import CoreHaptics

struct ContentView: View {
    @Environment(\.managedObjectContext) private var moc
    
    @State private var dice = DiceItem(sides: 0, numberOfDice: 0)
    @State private var sides: Int = 4
    @State private var numberOfDice: Int = 5
    @State private var isRotating: Bool = false
    @State private var engine: CHHapticEngine?
    @State private var runCount = 0
    
    let possibleSides = [4, 6, 8, 10, 12, 20, 100]
    var timer: Timer?

    
    var body: some View {
        TabView {
            NavigationView {
                VStack {
                    Form {
                        Section(header: Text("").accessibility(hidden: true)) {
                            VStack(alignment: .leading) {
                                Text("Sides per die")
                                Picker("", selection: $sides) {
                                    ForEach(possibleSides, id: \.self) {
                                        Text("\($0)")
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            VStack {
                                Stepper(value: $numberOfDice, in: 1 ... 9, step: 1) {
                                    HStack {
                                        Text("How many dice? ")
                                        Text("\(numberOfDice)")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .accessibility(value: Text("\(numberOfDice) dice"))
                            }
                        }
                        
                        HStack(alignment: .center) {
                            Spacer()
                            Button("ROLL!") {
                                withAnimation {
                                    self.spin()
                                }
                            }
                            .foregroundColor(.white)
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .shadow(radius: 4.0, x: 2.0, y: 2.0)
                            
                            Spacer()
                        }
                        
                        VStack {
                            HStack {
                                Spacer()
                                DiceView(dice: $dice, isRotating: $isRotating)
                                Spacer()
                            }
                        }
                        
                    }
                }
            
                //.navigationBarTitle(Text("ROLL MY DICE"), displayMode: .large)
                .toolbar {
                            ToolbarItem(placement: .principal) {
                                HStack {
                                    Image(systemName: "die.face.6")
                                        .rotationEffect(.degrees(-45))
                                    Text("ROLL MY DICE")
                                    Image(systemName: "die.face.6.fill")
                                        .rotationEffect(.degrees(45))
                                }
                                .font(.title2)
                                .foregroundColor(.blue)
                                .padding(.top)
                            }
                        }
            
            }
            
            .onAppear(perform: prepareHaptics)
            .tabItem {
                Image(systemName: "die.face.3.fill")
                Text("Dice")
            }
            
            
            NavigationView {
                DiceHistory()
                    .navigationBarTitle(Text("Your Scores"), displayMode: .inline)
                    .navigationBarItems(trailing: EditButton())
            }
            
            .tabItem {
                Image(systemName: "square.fill.text.grid.1x2")
                Text("Scores")
            }
        }
    }
    
    func spin() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            runCount += 1
            
            let ints = randomizeDice()
            
            dice = DiceItem(sides: sides, values: ints, numberOfDice: numberOfDice)
            
            isRotating.toggle()
            
            if runCount == 5 {
                timer.invalidate()
                runCount = 0
                save(ints: ints)
                isRotating = false
            }
        }
    }
    
    func randomizeDice() -> [Int] {
        var ints: [Int] = []
        for _ in 0 ..< numberOfDice {
            let randomInt = Int.random(in: 1 ... sides)
            ints.append(randomInt)
        }
        return ints
    }
    
    func save(ints: [Int]) {
        let stringArray = ints.map { String($0) }
        
        let temp = Dice(context: moc)
        temp.sides = Int16(sides)
        temp.number = Int16(numberOfDice)
        temp.values = stringArray.joined(separator: ",")
        
        try? moc.save()
        
        complexSuccess()
    }
    
    func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("Error creating engine: \(error.localizedDescription)")
        }
    }
    
    func complexSuccess() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 1 + i)
            
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed playing pattern: \(error.localizedDescription)")
        }
    }
}
            

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
           
           
