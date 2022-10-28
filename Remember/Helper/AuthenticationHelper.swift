import SwiftUI
import LocalAuthentication


/// Contains functionality for biometric authentification (FaceID, TouchID, ...)
struct AuthenticationHelper {
    
    @Binding var isUnlocked: Bool
    @State var reason: String
        
    /// Tries to authenticati the user with biometric features (FaceId, TouchId...). This code should not be used in the final application since there is no fallback-mechanism if no biometric authentication is available. This could potentially lock the user out of the app if he/she activates biometric authentication for the app and later deactivates biometric authentication in the system iOS settings.
    func authenticate() {
        let context = LAContext()
        
        AuthenticationHelper.checkIfBiometricsAreAvailable() {
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
            // no biometrics available
            isUnlocked = false
        }
    }
    
    /// Checks if the user's device can be used with biometric authentication (FaceID, TouchID...)
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
}
