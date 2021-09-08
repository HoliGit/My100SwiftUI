//
//  AstronautView.swift
//  Moonshot
//
//  Created by EO on 08/07/21.
//

import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    var body: some View {
        
        let astronautMissions: [Mission] = missions.filter { mission in
            mission.crew.contains(where: { $0.name == self.astronaut.id})
        }
        
        return GeometryReader { geometry in
            ScrollView(.vertical){
                VStack {
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
                            .font(.headline)
                            .padding(.leading)
                        
                        List(astronautMissions, id: \.id){
                            Text("\($0.displayName)")
                        }
                        
                    }
                    
                        
                }
            }
            
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
