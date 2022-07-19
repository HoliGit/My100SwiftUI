//
//  MissionView.swift
//  Moonshot
//
//  Created by EO on 08/07/21.
//  Updated on 18/07/22

import SwiftUI

struct MissionView: View {
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
   
    let mission: Mission
    let astronauts: [CrewMember]
    
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                VStack {
                    //Day 94 challenge 1
                    GeometryReader { geo in
                        HStack {
                            Spacer()
                            VStack {
                                Text(mission.displayName)
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                Image(decorative: self.mission.image)
                                    .resizable()
                                    .scaledToFit()
                            }
                            .frame(minWidth: fullView.size.width * 0.7)
                            .scaleEffect(calculateScale(geo: geo), anchor: .bottom)
                            
                            Spacer()
                        }
                    }
                    .frame(minWidth: fullView.size.width, minHeight: fullView.size.width * 0.7)

                    //challenge 1: add launch date below mission badge
                    Text("Launch date: \(self.mission.formattedLaunchDate)")
                        .font(.headline)
                    
                    Text(self.mission.description)
                        .padding()
                    
                    Text("Crew")
                        .font(.title)
                    
                    ForEach(self.astronauts, id: \.role) {
                        crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut, missions: MissionView.missions)) {
                            
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                
                                VStack(alignment: .leading){
                                    
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        
                        .buttonStyle(PlainButtonStyle()) //content of navigation link
                    }
                    
                    Spacer(minLength: 25)
                }
            }
            
        }
        //.navigationBarTitle(Text(mission.displayName), displayMode: .large)
        
    }
    
    init(mission: Mission){
        self.mission = mission
        
        
        var matches = [CrewMember]()
        //a new array of CrewMember
        
        
        for member in mission.crew {
            if let match = MissionView.astronauts.first(where: { $0.id == member.name}) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        self.astronauts = matches
    }
    
    //day 94 challenge 1
    private func calculateScale(geo: GeometryProxy) -> CGFloat {
            return ((geo.frame(in: .global).midY * 2) /
                geo.frame(in: .local).height) > 0.8 ?
                0.8 :
                max((geo.frame(in: .global).midY * 2) / geo.frame(in: .local).height, 0.4)
        }
    
    
    
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")
    static var previews: some View {
        MissionView(mission: missions[0])
    }

    }
