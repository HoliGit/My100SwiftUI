//
//  AstronautView.swift
//  Moonshot
//
//  Created by EO on 08/07/21.
//  Updated on 18/07/22

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    var missions: [Mission]
    
    init(astronaut: Astronaut, missions: [Mission]) {
            self.astronaut = astronaut
            self.missions = missions
            
            var matches = [Mission]()
            
            for mission in missions {
                if let match = mission.crew.first(where: {$0.name == self.astronaut.id}) {
                    matches.append(mission)
                }
            }
            self.missions = matches
        }
    
    var body: some View {
        
        GeometryReader { geometry in
            ScrollView(.vertical){
                VStack {
                    Text(astronaut.name)
                        .font(.largeTitle)
                    Image(self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)
                        .accessibility(hidden: true) //day76 challenge3
                    
                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1) //in case description gets clipped
                    
                    VStack(alignment: .leading){
                        
                        //challenge 2 adding astronaut's missions
                        Text("Apollo Missions")
                            .font(.title)
                            .padding(.leading)
                        
                        ForEach(self.missions) { mission in
                            NavigationLink(destination: MissionView(mission: mission)) {
                            HStack{
                                Image(mission.image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 44, height: 44)
                                VStack(alignment: .leading) {
                                    Text(mission.displayName)
                                        .font(.headline)
                                    Text(mission.formattedLaunchDate)
                                        .foregroundColor(.white.opacity(0.7))
                                }
                            }
                            .padding()
                            .clipShape(RoundedRectangle(cornerRadius: 3))
                            .overlay(Capsule().stroke(.lightBackground, lineWidth: 1))
                          }
                        }
                    }
                    
                        
                }
                
            }
            
            
        }
        //.navigationBarTitle(Text(astronaut.name), displayMode: .large)
        
        
    }
        

    
    
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static var previews: some View {
        AstronautView(astronaut: astronauts[0], missions: missions)
    }
}
