//
//  MemoriesListView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct MemoriesListView: View {
    
    
    @StateObject private var viewModel: ViewModel = ViewModel()
    @EnvironmentObject var memories: Memories

    
    var body: some View {
        
        NavigationView {
                List {
                    ForEach(memories.memories) { memory in
                        MemoryListEntryView(memory: memory)
                    }.onDelete {
                        memories.remove(at: $0)
                    }
                }
                .navigationTitle("Memories")
                .toolbar {
                    ToolbarItem() {
                        EditButton()
                    }
                    ToolbarItem(placement: .bottomBar) {
                        Button("Add Memory") {
                            viewModel.showAddMemoryView()
                        }.padding()
                    }
                }
            
        }.sheet(isPresented: $viewModel.showAddMemorySheet) {
            AddMemoryView()
        }
    }
}

struct MemoriesListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let memories = Memories()
        
        return MemoriesListView()
            .environmentObject(memories)
    }
}

