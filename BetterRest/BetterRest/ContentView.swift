//
//  ContentView.swift
//  BetterRest
//
//  Created by EO on 25/06/21.
//

import SwiftUI


struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    init() { UITableView.appearance().backgroundColor = .init(red: 178/255, green: 168/255, blue: 213/255, alpha: 0.5)
        }
    
    var body: some View {
        
        
        NavigationView {
            
            Form {
                
                Section(header: Text("When would you like to wake up?") .font(.headline)) {
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(DefaultDatePickerStyle())
                }
                
                
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.50) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                
                Section(header: Text("Daily coffee intake")) {
                    
                    Picker("Daily coffee intake", selection: $coffeeAmount) {
                        ForEach(1..<13) {
                            if $0 == 1 {
                                Text("1 cup")
                            } else {
                                Text("\($0) cups")
                            }
                        }
                        .labelsHidden()
                    }
                    
                }
                
                Section(header: Text("Your recommended bedtime is...")){
                    Text("\(calculateBedtime())")
                        .font(.largeTitle)
                        .foregroundColor(Color.blue)
                    
                }
                
                
            }
        
            .navigationBarTitle("BetterRest")
            .foregroundColor(.black)
            
            
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("Ok")))
                
            }
            
            
            
        }
        
        
      }
    
    
    
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() -> String {
        
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        
        let hour = (components.hour ?? 0) * 60 * 60
        
        let minute = (components.minute ?? 0) * 60
        
        var userMsg : String
        
        do{
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            userMsg = formatter.string(from: sleepTime)
            
            //alertMessage = formatter.string(from: sleepTime)
            //alertTitle = "Your ideal bedtime is..."
            
        } catch {
            // if something went wrong
            //alertTitle = "Error"
            //alertMessage = "Sorry, there was a problem calculating your bedtime"
            
            userMsg = "Sorry, there was a problem calculating your bedtime"
        }
        //showingAlert = true
        return userMsg
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
