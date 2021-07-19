//
//  ContentView.swift
//  Moonshot
//
//  Created by EO on 08/07/21.
//

import SwiftUI

struct ContentView: View {
    
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var showLaunchDate = true
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                    
                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        //challenge 3
                        if self.showLaunchDate {
                            Text(mission.formattedLaunchDate)
                        } else {
                            Text("\(self.missionCrew(mission))")
                        }
                    }
                }
                
            }
            .navigationBarTitle("Moonshot")
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
        return mission.crew.map {$0.name }.joined(separator: ", ")
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
