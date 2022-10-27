import SwiftUI

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
    
    var resetMemoriesNavigationLink: some View {
        NavigationLink {
            ResetMemoriesView()
        } label: {
            Text("Reset")
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                notificationNavigationLink
                deletedMemoriesNavigationLink
                resetMemoriesNavigationLink
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

