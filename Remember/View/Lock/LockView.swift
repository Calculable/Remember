import SwiftUI


/// Hides the app from the user until an unlock action (for example biometric authentication) is performed
struct LockView: View {
    
    var unlockAction: () -> Void
    
    var body: some View {
        
        NavigationView {
            Button("Unlock", action: unlockAction)
        }
        .onAppear(perform: unlockAction)
        
    }
}
