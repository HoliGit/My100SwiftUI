//
//  ContentView.swift
//  MyFriends
//
//  Created by EO on 30/08/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CDUser.entity(), sortDescriptors: [], predicate: nil) var cdusers: FetchedResults<CDUser>
    
    var body: some View {
        NavigationView{
            
            List(cdusers, id: \.id){ (user: CDUser) in
                NavigationLink(destination: CDUserView(user: user)){
                    HStack{
                        Image(systemName: "person.circle")
                            .resizable()
                            .frame(width: 40.0, height: 40.0)
                            .foregroundColor(user.isActive ? .green : .red)
                        Text(user.wrappedName)
                        Text("(\(user.friendsArray.count) friends)")
                    } .padding(5)
                }
                
            }
            
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        Text("\(cdusers.count)")
                    Text(Image(systemName: "person.circle"))
                        
                            }
                    .padding(.top, 10)
                        }
                     }
            
            .navigationBarItems(leading:
                VStack{
                        HStack {
                Image(systemName: "rectangle.stack.person.crop")
                    .resizable()
                    .frame(width: 40.0, height: 40.0)
                    //.padding(5)
                
                Text("MyFriends")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    }
                    
                    
                                    })
            .navigationBarTitleDisplayMode(.automatic)
            
            
        .onAppear(perform: loadData)
    }
}

func loadData() {
    guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
        print("Invalid URL")
        return
    }
    
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let data = data {
            if let decodedResponse = try? JSONDecoder().decode([User].self, from: data) {
                DispatchQueue.main.async {
                    
                    for user in decodedResponse {
                        let cdUser = CDUser(context: self.moc)
                        cdUser.id = user.id
                        cdUser.name = user.name
                        cdUser.isActive = user.isActive
                        cdUser.email = user.email
                        cdUser.company = user.company
                        cdUser.address = user.address
                        cdUser.about = user.about
                        cdUser.age = Int16(user.age)
                        
                        do {
                            try self.moc.save()
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    for user in decodedResponse {
                        guard let cdUser = self.cdusers.first(where: { $0.wrappedId == user.id }) else {
                            fatalError("User is missing")
                        }
                        
                        for friend in user.friends {
                            if !cdUser.friendsArray.contains(where: {$0.wrappedId == friend.id }) {
                                let cdFriend = CDFriend(context: self.moc)
                                cdFriend.id = friend.id
                                cdFriend.name = friend.name
                                cdUser.addToFriends(cdFriend)
                            }
                        }
                        
                        if self.moc.hasChanges {
                            do {
                                try self.moc.save()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                    
                    
                }
                
                return
            }
        }
        
        print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        
    }
    
    .resume()
  }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
