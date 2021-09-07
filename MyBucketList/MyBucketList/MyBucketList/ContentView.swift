//
//  ContentView.swift
//  MyBucketList
//
//  Created by EO on 06/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isUnlocked = false
    
    
    var body: some View {
        
        Group {
            
            if isUnlocked {
                DetailMapView()
            } else {
                
                AuthenticationView(isUnlocked: $isUnlocked)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
