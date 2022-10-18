//
//  DeletedMemoriesListView.swift
//  Remember
//
//  Created by Jan Huber on 02.10.22.
//

import SwiftUI

struct DeletedMemoriesListView: View {
    
    @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency;
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    
    //@StateObject private var viewModel: ViewModel = ViewModel()
    @EnvironmentObject var memories: Memories
    
    @State private var showDeleteConfirmationAlert = false
    
    var body: some View {
        
        Group {
            
        
        if memories.memoriesMarkedForDeletion.count > 0 {
            
        
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
                                
                                let increasedContrast = colorSchemeContrast == .increased
                    
                                getListBackground(memory: memory, withReducedTransparency: accessibilityReduceTransparency, withIncreasedContrast: increasedContrast).frame(minHeight: 158).frame(width: geo.size.width).clipped()

                        })
                        
                        .listRowSeparatorTint(.gray)
                        .listStyle(.insetGrouped)

                    }




                }
        } else {
            Text("No deleted memories")
        }

               
        }
        .toolbar {
            ToolbarItem() {
                Button {
                    //show confirmation dialog
                    showDeleteConfirmationAlert = true
                    
                } label: {
                    Label("Delete Forever", systemImage: "xmark.bin.fill")
                }.disabled(memories.memoriesMarkedForDeletion.count == 0)
                    .alert("Delete Forever", isPresented: $showDeleteConfirmationAlert) {
                        Button("Delete", role: .destructive, action: {
                            memories.deleteMarkedMemories()
                        })
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Are you sure? Finally deleted memories cannot be restored anymore.")
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

