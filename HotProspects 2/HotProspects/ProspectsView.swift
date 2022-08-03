//
//  ProspectsView.swift
//  HotProspects
//
//  Created by EO on 16/09/21.
//  Updated on 01/08/22

import CodeScanner
import SwiftUI
import UserNotifications

struct ProspectsView: View {
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortingOption {
        case name, recent
    }
    
    /*when using @EnvOb if the object is not present in the environment by the time the view is created, the app crashes!*/
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var showingSortingOptions = false
    @State private var sortingOption : SortingOption = .name
    
    let filter: FilterType
    
    var title: String {
        
        switch filter {
            case .none:
                return "Everyone"
            case .contacted:
                return "Contacted"
            case .uncontacted:
                return "Uncontacted"
        }
    }
    
    var filteredProspects: [Prospect] {
        
        switch filter {
            case .none:
                return prospects.people
                
            case .contacted:
                return prospects.people.filter { $0.isContacted }
                
            case .uncontacted:
                return prospects.people.filter { !$0.isContacted}
        }
    }
    
    var filteredSortedProspects: [Prospect] {
        switch sortingOption {
            case .name:
                return filteredProspects.sorted { $0.name < $1.name }
            case .recent:
                return filteredProspects.sorted { $0.date > $1.date }
        }
    }

    
    var body: some View {
         
        NavigationView {
            VStack{
            Text("Press a contact to mark it Un/Contacted and to set a Reminder")
                    .foregroundColor(.blue)
                    .padding()
            List{
                ForEach(filteredSortedProspects) { prospect in
                    HStack {
                        //Challenge 1
                        Image(systemName: prospect.isContacted ? "person.fill.checkmark" : "person.fill.questionmark")
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                            //My Extra: adding date
                            Text("Added on \(prospect.addingDate, formatter: formattedDate)")
                                .foregroundColor(.secondary)
                        }
                        
                        .contextMenu {
                            Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                                self.prospects.toggle(prospect)
                            }
                            
                            if !prospect.isContacted {
                                Button("Remind me") {
                                    self.addNotification(for: prospect)
                                }
                            }
                        }
                        
                    }
                }
                .onDelete {
                    (offset) in
                    for i in offset {
                        if let found = filteredProspects.firstIndex(where: { $0.id == filteredProspects[i].id }) {
                            let idx: IndexSet = IndexSet(integer: found)
                            prospects.remove(at: idx)
                        }
                    }
                }
                
            }
            }
            .navigationBarTitle(title)
            .navigationBarItems(leading: Button("Sort"){
                self.showingSortingOptions.toggle()
            }, trailing: Button(action: {
                self.isShowingScanner = true
            }) {
                Image(systemName: "qrcode.viewfinder")
                Text("Scan")
            })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Benjamin Sisko\ncaptain@ds9.space", completion: self.handleScan)
            }
            
            .actionSheet(isPresented: $showingSortingOptions) { () -> ActionSheet in
                ActionSheet(title: Text("Sort contacts"), message: Text("Select sorting style"), buttons: [
                    .default(Text((self.sortingOption == .name ? "☞ " : "") + "Name"), action:  { self.sortingOption = .name }),
                    .default(Text((self.sortingOption == .recent ? "☞ " : "") + "Most recent"), action:  { self.sortingOption = .recent }),
                    .cancel()
                ])
                
            }
        }
        
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
            case .success(let result):
                let details = result.string.components(separatedBy: "\n")
                guard details.count == 2 else { return }
                
                let person = Prospect()
                person.name = details[0]
                person.emailAddress = details[1]
                self.prospects.add(person)
                
            case .failure(let error):
                print("Scanning failed: \(error.localizedDescription)")
        }
        
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 9
            
            // COMMENTED OUT TO MAKE TESTING EASIER
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Mah")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
