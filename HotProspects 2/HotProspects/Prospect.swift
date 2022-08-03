//
//  Prospect.swift
//  HotProspects
//
//  Created by EO on 16/09/21.
//  Updated on 01/08/22

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    var addingDate = Date()
    fileprivate(set) var isContacted = false
    
    var date = Date()
}
    //My Extra: adding date
    var formattedDate : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy"
        return formatter
    }()

@MainActor class Prospects: ObservableObject {
    @Published private(set) var people : [Prospect]
    let saveKey = "SavedData"
    
    init() {
        //challenge 2
        if let savedPeople = FileManager().load(withName: saveKey) {
            self.people = savedPeople
            return
        }
        
        self.people = []
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(people) {
            //UserDefaults.standard.set(encoded, forKey: Self.saveKey)
            FileManager().save(encoded, withName: saveKey)
        }
    }
    
    func add(_ prospect: Prospect) {
        people.append(prospect)
        save()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        save()
    }
    
    func remove(at offsets: IndexSet) {
        people.remove(atOffsets: offsets)
            save()
        }
}

//challenge 2
extension FileManager {
    
    func getDocumentDirectory() -> URL {
        
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save(_ userData: Data, withName name: String) {
        let url = getDocumentDirectory().appendingPathComponent(name)
        
        do {
            try userData.write(to: url, options: .atomicWrite)
            print("Saved to user document Directory")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func load(withName name: String) -> [Prospect]? {
        let url = getDocumentDirectory().appendingPathComponent(name)
        if let data = try? Data(contentsOf: url) {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                return decoded
            }
        }
        
        return nil
    }
    
}
