//
//  AddHabitView.swift
//  iTrack
//
//  Created by EO on 15/07/21.
//

import SwiftUI

struct ColumnTitle: View {
    var title: String
    
    var body: some View{
        Text(title)
            .frame(width: 200, height: 40, alignment: .leading)
        Spacer(minLength: 20)
    }
}

struct AddHabitView: View {
    //informi AddHabitView che è presente un Habit e visualizzi tramite @environment
    @ObservedObject var habit: Habit
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var description = ""
    @State private var completedTimes = ""
    @State private var showingAlert = false
    
    
    var body: some View { 
        NavigationView{
            VStack{
            Text("To start tracking a new activity, insert a name and a number of sessions. A short description is optional, but could be useful.")
                .font(.title2)
                .foregroundColor(.blue)
                .padding()
            
            Form {
                HStack {
                    ColumnTitle(title: "Activity")
                    TextField("Write a name", text: $name)
                        .keyboardType(.default)
                }
                
                HStack{
                    ColumnTitle(title: "Activity description")
                    TextField("Optional", text: $description)
                        .keyboardType(.default)
                }
                
                HStack{
                    ColumnTitle(title: "Completed sessions")
                    TextField("Type a number", text: $completedTimes)
                        .keyboardType(.numberPad)
                }
                
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button("Cancel"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    HStack{
                        Image(systemName: "pencil.tip.crop.circle.badge.plus")
                        Text("Add tracking")
                            .fontWeight(.bold)
                    }
                    .font(.title2)
                    //.foregroundColor()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save"){
                        if let realTimes = Int(self.completedTimes){
                            if !self.name.isEmpty && realTimes >= 0 {
                                let activity = Activity(name: self.name, description: self.description, completedTimes: realTimes)
                                self.habit.activities.append(activity)
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                self.showingAlert = true
                               }
                            
                        } else {
                                self.showingAlert = true
                            }
                        }
                    }
                }
                
                .alert(isPresented: $showingAlert, content: {
                    Alert(title: Text("ERROR"), message: Text("Please insert an integer number for your activity sessions"), dismissButton: .default(Text("OK")))
                })
            }
        }
        
      }
    }


struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView(habit: Habit())
    }
}
