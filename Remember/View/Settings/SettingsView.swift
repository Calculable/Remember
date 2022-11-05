import SwiftUI

/// Displays the app's settings overview
struct SettingsView: View {
    @EnvironmentObject private var memories: Memories
    
    var notificationNavigationLink: some View {
        NavigationLink {
            NotificationSettingsView()
        } label: {
            Text("Notifications")
        }
    }
    
    var deletedMemoriesNavigationLink: some View {
        NavigationLink {
            DeletedMemoriesListView()
        } label: {
            Text("Deleted Memories").badge(memories.memoriesMarkedForDeletion.count)
        }
    }
    
    var importAndExportNavigationLink: some View {
        NavigationLink {
            ImportAndExportView()
        } label: {
            Text("Import and Export")
        }
    }
    
    var privacyPolicyNavigationLink: some View {
        Link(destination: URL(string: "https://www.jan-huber.ch/remember-app/privacy-policy")!, label: {
            Text("Privacy Policy")
        })
    }
    
    var contactNavigationLink: some View {
        Link(destination: URL(string: "https://www.jan-huber.ch/remember-app/contact")!, label: {
            Text("Contact & Support")
        })
    }
    
    var resetMemoriesNavigationLink: some View {
        NavigationLink {
            ResetMemoriesView()
        } label: {
            Text("Reset").foregroundColor(.red)
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    notificationNavigationLink
                    deletedMemoriesNavigationLink
                    importAndExportNavigationLink
                }
                
                Section {
                    contactNavigationLink
                    privacyPolicyNavigationLink
                }
                
                Section {
                    resetMemoriesNavigationLink
                }
            }
            .navigationTitle("Settings")
        }
        .navigationViewStyle(.stack)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

