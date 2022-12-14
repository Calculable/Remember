import SwiftUI


/// Displays the privacy settings containing the option to turn on or off the biometric authentication. This view is not (yet) part of the final application since a fallback-option is missing for the biometric authentication. This would lead to a problem if the biometric authentication is turned on for the app and later turned off system-wide in the iOS Settings.
struct PrivacySettingsView: View {
    @EnvironmentObject private var memories: Memories
    @AppStorage("biometric.authentication.enabled") private var enableBiometricAuthentication = false
    @State private var showBiometricsNotAvailableAlert = false
    
    var body: some View {
        Form {
            Text("You can use Face ID or Touch ID to unlock the app. Please note that the data will be accessible if biometrics are disabled for this device.")
                .font(.callout)
                .alert("Biometrics not available", isPresented: $showBiometricsNotAvailableAlert) {
                    Button("OK", role: .cancel) {
                    }
                } message: {
                    Text("Biometrics are disabled or not supported on this device")
                }
            Section {
                Toggle(isOn: $enableBiometricAuthentication) {
                    Text("Enable biometric authentication (if available)")
                }
                .onChange(of: enableBiometricAuthentication == true, perform: { _ in
                    checkIfBiometricsAvailable()
                })
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func checkIfBiometricsAvailable() {
        if (enableBiometricAuthentication) {
            AuthenticationHelper.checkIfBiometricsAreAvailable() {
            } onError: { _ in
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

