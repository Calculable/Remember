import Foundation
import SwiftUI

extension MemoriesListView {
    
    /// The view model for the MemoriesListView
    @MainActor class ViewModel: ObservableObject {
        
        /// Stores if the user cas ever delted a memory. If the user has never deleted a memory, a notification can be shown when a memory is deleted for the first time
        @AppStorage("neverDeletedAMemory") private var neverDeletedAMemory = true
        
        ///used show a notification about data-handling after the user saves a memory for the first time
        @AppStorage("neverCreatedAMemory") var neverCreatedAMemory = true

        @Published var showAddMemorySheet = false
        @Published var showDeleteMemoryAlert = false
        @Published var searchText = ""
        @Published var showDataHandlingAlert = false

        func markMemoryForDeletion(memories: Memories, memory: Memory) {
            memories.markForDeletion(memory)
            
            if (neverDeletedAMemory) {
                //show notification if the user has never delted a memory before
                showDeleteMemoryAlert = true
            }
            neverDeletedAMemory = false
        }
        
        func showAddMemoryView() {
            showAddMemorySheet = true
        }
        
        func showDataHandlingAlertView() {
            neverCreatedAMemory = false
            showDataHandlingAlert = true
        }
    }
}
