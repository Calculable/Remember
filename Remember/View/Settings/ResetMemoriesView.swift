import SwiftUI


/// This view is part of the settings and allows the user to reset the data for this app. If the data is reseted, all the user-created memories are deleted and a list of default memorires gets imported to the app
struct ResetMemoriesView: View {
    
    @EnvironmentObject private var memories: Memories
    @State private var showConfirmationAlert = false
    @State private var showDeletionSuccessDialog = false
    
    var body: some View {
        Form {
            Text("Warning: This step can not be undone")
                .fixedSize(horizontal: false, vertical: true)
                .font(.callout)
            
            Section {
                Button("Remove all custom memories", role: .destructive) {
                    displayConfirmationAlert()
                }
                .disabled(memories.memories.isEmpty)
            }
            .alert("Delete custom memories", isPresented: $showConfirmationAlert) {
                Button("Delete", role: .destructive, action: {
                    removeAllMemories()
                })
                Button("Cancel", role: .cancel) {
                }
            } message: {
                Text("Are you sure to delete all your memories? This step can not be undone.")
            }
            .alert("Memories deleted", isPresented: $showDeletionSuccessDialog) {
                Button("OK", role: .cancel) {
                }
            } message: {
                Text("The memories were successfully deleted")
            }
        }
        .navigationTitle("Reset").navigationBarTitleDisplayMode(.inline)
    }
    
    private func removeAllMemories() {
        memories.removeAllMemories()
        showDeletionSuccessDialog = true
    }
    
    private func displayConfirmationAlert() {
        showConfirmationAlert = true
    }
}

struct ResetMemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        ResetMemoriesView()
    }
}
