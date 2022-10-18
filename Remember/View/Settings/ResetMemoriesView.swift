//
//  ResetMemoriesView.swift
//  Remember
//
//  Created by Jan Huber on 18.10.22.
//

import SwiftUI

struct ResetMemoriesView: View {
    
    @EnvironmentObject var memories: Memories
    @State private var showConfirmationAlert = false
    @State private var showDeletionSuccessDialog = false

    
    var body: some View {
        Form {
                                        
            Text("Warning: This step can not be undone")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.callout)
            
            Section {
                Button("Remove all custom memories", role: .destructive) {
                    showConfirmationAlert = true
                    
                }.disabled(memories.memories.count == 0)
            }
            .alert("Delete custom memories", isPresented: $showConfirmationAlert) {
                Button("Delete", role: .destructive, action: {
                    memories.removeAllMemories()
                    showDeletionSuccessDialog = true
                })
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Are you sure to delete all your memories? This step can not be undone.")
            }
            .alert("Memories deleted", isPresented: $showDeletionSuccessDialog) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The memories were successfully deleted")
            }
            
        }.navigationTitle("Reset").navigationBarTitleDisplayMode(.inline)

        
    }
    
}

struct ResetMemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        ResetMemoriesView()
    }
}