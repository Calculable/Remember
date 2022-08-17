//
//  MemoriesListView-ViewModel.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import Foundation

extension MemoriesListView {
    @MainActor class ViewModel: ObservableObject {

        @Published var showAddMemorySheet = false
        
        func showAddMemoryView() {
            showAddMemorySheet = true
        }

    }
}
