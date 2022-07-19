//
//  ContentView.swift
//  Moonshot
//
//  Created by EO on 08/07/21.
//  Updated on 18/07/22 
//

import SwiftUI

@available(iOS 15.0, *)
struct ContentView: View {
    
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showLaunchDate = true
    
    let columns = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    let backgroundGradient = LinearGradient(
        gradient: Gradient(colors: [Color.pink, Color.yellow]),
        startPoint: .top, endPoint: .bottom)
    
    
    var body: some View {
        
        NavigationView {
            
            ScrollView {
                Text("MOONSHOT").font(.custom("Nasalization", size: 36))
                LazyVGrid(columns: columns) {
                    ForEach(missions) { mission in
                        NavigationLink {
                            MissionView(mission: mission)
                        } label: {
                            VStack {
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100, height: 100)
                                    .padding()
                                
                                
                                VStack {
                                    Text(mission.displayName)
                                        .font(.title)
                                        .foregroundColor(.white)
                                    //challenge 3
                                    if self.showLaunchDate {
                                        Text(mission.formattedLaunchDate)
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.7))
                                    } else {
                                        Text("\(self.missionCrew(mission))")
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.lightBackground)
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(RoundedRectangle(cornerRadius: 10) .stroke(.lightBackground))
                        }
                    }
                }
                .padding([.horizontal,.bottom])
            
            }
            //.navigationBarTitle("Moonshot")
            .navigationBarTitleDisplayMode(.large)
            .preferredColorScheme(.dark)
            .navigationBarItems(trailing:
                                    Button(action: {
                self.showLaunchDate.toggle()
            }) {
                Text(showLaunchDate ? "Show crew" : "Show launch date")
            }
            )
        }
        
        }
    
    //challenge 3
    func missionCrew(_ mission: Mission) -> String {
        return mission.crew.map {$0.name .capitalized }.joined(separator: ", ")
    }
    
}




@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
