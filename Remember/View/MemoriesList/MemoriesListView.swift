//
//  MemoriesListView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct MemoriesListView: View {

    @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency;
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @EnvironmentObject var memories: Memories
    @AppStorage("neverDeletedAMemory") var neverDeletedAMemory = true
    @State private var showAddMemorySheet = false
    @State private var showDeleteMemoryAlert = false
    @State private var searchText = ""

    func showAddMemoryView() {
        showAddMemorySheet = true
    }
    
    
    var body: some View {
        
        NavigationView {
                List {
                    ForEach(memories.filteredMemories(searchText: searchText)) { memory in
                        
                        NavigationLink {
                            MemoryDetailView(memory: memory)
                        } label: {
                            
                            MemoryListEntryView(memory: memory)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        
                                        markMemoryForDeletion(memory: memory)

                                    
                                    } label: {
                                        Label("Delete", systemImage: "minus.circle")
                                    }
                                }.alert("Memory deleted", isPresented: $showDeleteMemoryAlert) {
                                    Button("OK", role: .cancel) { }
                                } message: {
                                    Text("Deleted Memories can be restored under Settings > Deleted Memories")
                                }
                            

                                
                        }.swipeActions(edge: .leading) {
                            Button {
                                memories.toggleNotifications(for: memory)
                            } label: {
                                if memory.notificationsEnabled {
                                    Label("Disable Notifications", systemImage: "bell.slash")
                                } else {
                                    Label("Enable Notifications", systemImage: "bell")
                                }
                                
                            }
                            .tint(memory.notificationsEnabled ? .gray : .purple)
                        }

                        .listRowBackground(
                            GeometryReader { geo in
                                let increasedContrast = colorSchemeContrast == .increased
                                getListBackground(forMemory: memory, withReducedTransparency: accessibilityReduceTransparency, withIncreasedContrast: increasedContrast).frame(minHeight: 158).frame(width: geo.size.width).clipped()

                        })
                        
                        //.listRowSeparator(.hidden)
                        .listRowSeparatorTint(.gray)
                        .listStyle(.insetGrouped)

                    }





                }
                .searchable(text: $searchText, prompt: "Search memory")


                .environment(\.defaultMinListRowHeight, 160)
                .navigationTitle("Memories")
                .toolbar {
                    ToolbarItem() {
                        Button {
                            showAddMemoryView()
                        } label: {
                            Label("Add Memory", systemImage: "plus")
                        }
                    }
                }
            
            Text("Please select a memory to see the details")

        }
        .phoneOnlyStackNavigationView()
        .sheet(isPresented: $showAddMemorySheet) {
            EditMemoryView()
        }
    }
    
    func markMemoryForDeletion(memory: Memory) {
        memories.markForDeletion(memory)
        
        if (neverDeletedAMemory) {
            //show notification
            
            showDeleteMemoryAlert = true

        }
        
        neverDeletedAMemory = false
        
    }
    

}

struct MemoriesListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let memories = Memories()
        
        return MemoriesListView()
            .environmentObject(memories)
    }
}

