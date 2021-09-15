//
//  ContentView.swift
//  NameMyPic
//
//  Created by EO on 10/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Shot.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    
    var shots: FetchedResults<Shot>
    
    @State private var showDetail = false
    
    let dataManager = DataManager()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(shots, id: \.self) { (shot: Shot) in
                    NavigationLink(destination: DetailView(person: shot)) {
                        self.dataManager.loadImage(for: shot)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 54, height: 54 )
                        Text("\(shot.wrappedName)")
                            .padding(5)
                    }
                    
                }
                
                .navigationBarTitle("NAME MY PIC", displayMode: .inline)
                
                .navigationBarItems(trailing:
                                        Button(action: {
                                            self.showDetail = true
                                        }) {
                                            HStack {
                                                Image(systemName: "pencil.tip.crop.circle.badge.plus")
                                                    //.padding()
                                            }
                                        }
                )
                
            }
            
            .sheet(isPresented: $showDetail) {
                EntryView(context: self.context)
            }
            
        }
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

