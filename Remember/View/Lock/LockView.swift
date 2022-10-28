import SwiftUI


/// Hides the app from the user until an unlock action (for example biometric authentication) is performed
struct LockView: View {
    
    
    /// action to be performed to unlock the app. Usually this is some kind of authentication (Pin, FaceID, TouchID, ...)
    var unlockAction: () -> Void
    
    var body: some View {
        
        NavigationView {
            Button("Unlock", action: unlockAction)
        }
        .onAppear(perform: unlockAction)
        
    }
}
