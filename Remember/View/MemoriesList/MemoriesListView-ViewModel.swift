import Foundation
import SwiftUI

extension MemoriesListView {
    
    /// The view model for the MemoriesListView
    @MainActor class ViewModel: ObservableObject {
        
        @AppStorage("neverDeletedAMemory") private var neverDeletedAMemory = true
        @Published var showAddMemorySheet = false
        @Published var showDeleteMemoryAlert = false
        @Published var searchText = ""
        
        func markMemoryForDeletion(memories: Memories, memory: Memory) {
            memories.markForDeletion(memory)
            
            if (neverDeletedAMemory) {
                //show notification
                showDeleteMemoryAlert = true
            }
            
            neverDeletedAMemory = false
        }
        
        func showAddMemoryView() {
            showAddMemorySheet = true
        }
        
    }
}
