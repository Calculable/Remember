import Foundation
import SwiftUI

extension MemoriesListView {
    
    /// The view model for the MemoriesListView
    @MainActor class ViewModel: ObservableObject {
        
        /// Stores if the user cas ever delted a memory. If the user has never deleted a memory, a notification can be shown when a memory is deleted for the first time
        @AppStorage("neverDeletedAMemory") private var neverDeletedAMemory = true
        @Published var showAddMemorySheet = false
        @Published var showDeleteMemoryAlert = false
        @Published var searchText = ""
        
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
        
    }
}
