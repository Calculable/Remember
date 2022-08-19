//
//  NotificationSettingsView.swift
//  Remember
//
//  Created by Jan Huber on 17.08.22.
//

import SwiftUI


struct PrivacySettingsView: View {
        
    @EnvironmentObject var memories: Memories

    @AppStorage("biometric.authentication.enabled") private var enableBiometricAuthentication = false
    
   
    
    var body: some View {
        
        
        
        Form {
            
            Text("You can use Face ID or Touch ID to unlock the app. Please note that the data will be accessible if biometrics are disabled for this device.")
                .font(.callout)
            
            Section {
                
                Toggle(isOn: $enableBiometricAuthentication){
                         Text("Enable biometric authentication (if available)")
                      }
                
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct PrivacySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsView()
    }
}

