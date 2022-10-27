//
//  MemoriesListView-ViewModel.swift
//  Remember
//
//  Created by Jan Huber on 25.10.22.
//

import Foundation
import SwiftUI

extension MemoriesListView {
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
