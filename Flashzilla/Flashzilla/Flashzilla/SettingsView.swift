//
//  SettingsView.swift
//  Flashzilla
//
//  Created by EO on 29/09/21.
//

//challenge 2

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var retryWrongAnswers: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("Unanswered cards will be put at the end of the stack")) {
                    Toggle(isOn: $retryWrongAnswers) {
                        Text("Retry!")
                    }
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        
        }
    }
    
    func dismiss() {
        UserDefaults.standard.set(retryWrongAnswers, forKey: UserDefaultsKeys.RetryWrongAnswers.rawValue)
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(retryWrongAnswers: .constant(true))
    }
}
