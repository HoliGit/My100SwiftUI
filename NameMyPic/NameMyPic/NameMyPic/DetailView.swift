//
//  DetailView.swift
//  NameMyPic
//
//  Created by EO on 13/09/21.
//  
//

import SwiftUI

struct DetailView: View {
    
    @State private var showMapSheet = false
    
    let person: Shot
    
    let dataManager = DataManager()
    
    private var image: Image {
        dataManager.loadImage(for: person)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Name:  ")
                    .font(.headline)
                    .padding()
                Text(person.wrappedName)
                Spacer()
            }
            ZStack {
                image
                    .resizable()
                    .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 5.0)
            .padding(.vertical, 50.0)
            
            Button(action: {
                self.showMapSheet = true
            }) {
                Text("Location Map")
                .padding(5)
                    .font(.system(size: 22))
            }
            .background(Color.blue)
            .foregroundColor(.white)
            .font(.title)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            Spacer()
                        
        }
        .sheet(isPresented: $showMapSheet) {
            MapSheet(centreCoordinate: person.coordinate)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let person = FetchRequest<Shot>(entity: Shot.entity(), sortDescriptors: []).wrappedValue.first!
        return DetailView(person: person)
    }
}
