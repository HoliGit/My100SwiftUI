//
//  AuthenticationView.swift
//  MyBucketList
//
//  Created by EO on 06/09/21.
//

import SwiftUI
import LocalAuthentication

struct AuthenticationView: View {
    
    @Binding var isUnlocked: Bool
    @State private var showingAlert = false
    @State private var alertTitle = "Title"
    @State private var alertMessage = "Message"
    
    
    var body: some View {
        
        Button("Unlock Places"){
            self.authenticate()
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("\(alertTitle)"), message: Text("\(alertMessage)"), dismissButton: .default(Text("Ok")))
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                    } else {
                        
                        alertTitle = "Authentication error"
                        alertMessage = authenticationError?.localizedDescription ?? "Unknown error"
                        showingAlert = true
                    }
                }
                
            }
        } else {
            //no biometrics
            alertTitle = "No biometrics"
            alertMessage = error?.localizedDescription ?? "This device does not support biometric authentication"
            showingAlert = true
        }
    }
    
    
}//last!

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView(isUnlocked: .constant(false))
    }
}
