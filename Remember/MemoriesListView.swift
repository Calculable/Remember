//
//  MemoriesListView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct MemoriesListView: View {
    
    @StateObject private var viewModel = ViewModel()
    
    @ObservedObject var model: Memories

    
    var body: some View {
        
        NavigationView {
            
                
                
                List {
                    ForEach(model.memories) { memory in
                        MemoryListEntryView(memory: memory)
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
            AddMemoryView(model: model)
        }


        
    }
}

struct MemoriesListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let memories = Memories()
        memories.loadExampleMemories()
        
        return MemoriesListView(model: memories)
    }
}

