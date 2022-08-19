//
//  AuthenticationHelper.swift
//  Remember
//
//  Created by Jan Huber on 19.08.22.
//

import SwiftUI
import LocalAuthentication

struct AuthenticationHelper {
    
    @Binding var isUnlocked: Bool
    
    static func checkIfBiometricsAreAvailable(onSuccess: (() -> Void)?, onError: ((NSError?) -> Void)?) {
        let context = LAContext()
        var error: NSError?
        
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            onSuccess?()
        } else {
            // no biometrics
            onError?(error)
        }
        
        
    }
    
    func authenticate() {
        
        let context = LAContext()
        
        AuthenticationHelper.checkIfBiometricsAreAvailable() {
            // it's possible, so go ahead and use it
            let reason = "We need to unlock your data."

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // authentication has now completed
                if success {
                    isUnlocked = true
                } else {
                    // there was a problem
                    isUnlocked = false
                }
            }
        } onError: { _ in
            // no biometrics
            isUnlocked = true //! a note was added to the UI to inform the user that the data will be accessible if biometrics are disabled in the system settings
        }


      
    }
    
    
}
