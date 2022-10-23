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
    
    @State private var showBiometricsNotAvailableAlert = false
    
    var body: some View {
        
        
        
        Form {
            
            Text("You can use Face ID or Touch ID to unlock the app. Please note that the data will be accessible if biometrics are disabled for this device.")
                .font(.callout)
                .alert("Biometrics not available", isPresented: $showBiometricsNotAvailableAlert) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text("Biometrics are disabled or not supported on this device")
                        }
            
            Section {
                
                Toggle(isOn: $enableBiometricAuthentication){
                         Text("Enable biometric authentication (if available)")
                }.onChange(of: enableBiometricAuthentication == true , perform: { _ in
                    checkIfBiometricsAvailable()
                })
     
                 
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
    //checkIfBiometricsAreAvailable
    
    func checkIfBiometricsAvailable() {
        if (enableBiometricAuthentication) {
            AuthenticationHelper.checkIfBiometricsAreAvailable() {} onError: { _ in
                enableBiometricAuthentication = false
                showBiometricsNotAvailableAlert = true
                
            }
        }
    }
}

struct PrivacySettingsView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacySettingsView()
    }
}

