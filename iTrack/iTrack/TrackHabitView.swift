//
//  TrackHabitView.swift
//  iTrack
//
//  Created by EO on 15/07/21.
//

import SwiftUI

struct TrackHabitView: View {
    
    @ObservedObject var habit: Habit
    
    var index: Int
    
    var body: some View {
        NavigationView{
            VStack(spacing: 50){
                
                VStack{
                    Text(self.habit.activities[index].name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text(self.habit.activities[index].description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Button(action: {
                    self.habit.activities[self.index].completedTimes += 1
                }, label: {
                    Image(systemName: "goforward.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.green)
                    Text("Add a session")
                        .fontWeight(.bold)
                })
                
                HStack{
                    Text("You completed ")
                    Text("\(habit.activities[index].completedTimes)")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                        .padding()
                        .overlay(Circle()
                                    .stroke(Color.blue, lineWidth:2))
                    Text(" sessions!")
                }
                
                
                Button(action: {
                    self.habit.activities[self.index].completedTimes -= 1
                }, label: {
                    Image(systemName: "gobackward.minus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.red)
                    Text("Cut a session")
                        .fontWeight(.bold)
                })
                
            }
            
            .padding(30)
            
            //Spacer()
        }
        
        
        .navigationBarTitleDisplayMode(.inline)
        
        .toolbar{
            ToolbarItem(placement: .principal){
                VStack{
                    Text("Update your activity")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Add or cut your sessions")
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                     }
                .padding()
            }
        }
    }
    
}
    
    struct TrackHabitView_Previews: PreviewProvider {
        static var previews: some View {
            TrackHabitView(habit: Habit(), index: 30)
        }
    }
