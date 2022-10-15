//
//  DeletedMemoriesListView.swift
//  Remember
//
//  Created by Jan Huber on 02.10.22.
//

import SwiftUI

struct DeletedMemoriesListView: View {
    
    @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency;

    
    //@StateObject private var viewModel: ViewModel = ViewModel()
    @EnvironmentObject var memories: Memories
    
    var body: some View {
        
                List {
                    ForEach(memories.memoriesMarkedForDeletion) { memory in
                        
                        NavigationLink {
                            MemoryDetailView(memory: memory)
                        } label: {
                            
                            MemoryListEntryView(memory: memory, showNotificationSymbol: false)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        memories.remove(memory)
                                    
                                    } label: {
                                        Label("Delete", systemImage: "minus.circle")
                                    }
                                }
                            

                                
                        }.swipeActions(edge: .leading) {
                            Button {

                                //Do Something
                                memories.restore(memory)
                                
                            } label: {
                                Label("Restore", systemImage: "gobackward")
                                
                            }
                            .tint(.orange)
                        }

                        .listRowBackground(
                            GeometryReader { geo in
                    
                                getListBackground(memory: memory, withReducedTransparency: accessibilityReduceTransparency).frame(minHeight: 158).frame(width: geo.size.width).clipped()

                        })
                        
                        .listRowSeparator(.hidden)

                    }





                }

                .toolbar {
                    ToolbarItem() {
                        Button {
                            memories.deleteMarkedMemories()
                        } label: {
                            Label("Delete Forever", systemImage: "xmark.bin.fill")
                        }
                    }
                }
                .environment(\.defaultMinListRowHeight, 160)
                .navigationTitle("Deleted Memories")
                .navigationBarTitleDisplayMode(.inline)

        


    }
    

}

struct DeletedMemoriesListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let memories = Memories()
        
        return DeletedMemoriesListView()
            .environmentObject(memories)
    }
}

