//
//  ContentView.swift
//  iTrack
//
//  Created by EO on 15/07/21.
//

import SwiftUI

struct ListItem: View {
    var name: String
    var description: String
    var completedTimes: Int
    
    var body: some View{
        HStack{
            VStack(alignment: .leading){
                Text(name)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing){
                Text("\(completedTimes) sessions")
                    .font(.headline)
                Text("completed")
                    .foregroundColor(.secondary)
                
            }
        }
        .frame(height: 50)
    }
    
}

struct ContentView: View {
    @ObservedObject var habit = Habit()
    
    @State private var showingAddActivity = false
    @State private var isEditMode = false
    
    var body: some View {
        NavigationView{
            
            VStack{
                Text("iTRACK")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.blue)
                    //.padding()
                
                Text("Add & track your favorite activities")
                    .font(.headline)
                
                List{
                    
                    ForEach(habit.activities.indices, id: \.self) { index in
                        NavigationLink(destination: TrackHabitView(habit: self.habit, index: index)) {
                            ListItem(name: self.habit.activities[index].name, description: self.habit.activities[index].description, completedTimes: self.habit.activities[index].completedTimes)
                        }
                    }
                    
                    .onDelete(perform: removeActivities)
                }
    
                
                .toolbar {
                    
                    ToolbarItem(placement: .principal) {
                        VStack{
                            Spacer(minLength: 40)
                            
                            /*Text("iTrack")
                                .font(.largeTitle)
                                .fontWeight(.black)
            
                            Spacer(minLength: 12)*/
                            
                        }
                        
                      }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.showingAddActivity = true
                        }, label:{
                            HStack{
                                Image(systemName: "plus.square.fill.on.square.fill")
                            }
                        })
                        
                    }
                    
                    
                    ToolbarItem(placement: .navigationBarLeading){
                        EditButton()
                    }
                    
                }
                
                    //.navigationBarTitle("TITOLONE")
                
            }
            
            .sheet(isPresented: $showingAddActivity, content: {
                AddHabitView(habit: self.habit)
            })
        }
        
    }
    
    func removeActivities(at offsets: IndexSet){
        self.habit.activities.remove(atOffsets: offsets)
    }
    
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
