//
//  MemoriesListView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct MemoriesListView: View {

    @StateObject private var viewModel = ViewModel()

    @Environment(\.accessibilityReduceTransparency) var accessibilityReduceTransparency;
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @State private var searchText = ""
    
    @EnvironmentObject var memories: Memories
    
    @AppStorage("neverDeletedAMemory") private var neverDeletedAMemory = true
    @State var showDeleteMemoryAlert = false
    
    let notificationHelper = NotificationHelper()
    
    var body: some View {
        
        NavigationView {
                List {
                    ForEach(filteredMemories) { memory in
                        
                        NavigationLink {
                            MemoryDetailView(memory: memory)
                        } label: {
                            
                            MemoryListEntryView(memory: memory)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        
                                        markMemoryForDeletion(memory)

                                    
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
                                toggleNotification(forMemory: memory)
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

                                getListBackground(memory: memory, withReducedTransparency: accessibilityReduceTransparency, withIncreasedContrast: increasedContrast).frame(minHeight: 158).frame(width: geo.size.width).clipped()

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
                            viewModel.showAddMemoryView()
                        } label: {
                            Label("Add Memory", systemImage: "plus")
                        }
                    }
                }
            
            Text("Please select a memory to see the details")

        }
        .phoneOnlyStackNavigationView()
        .sheet(isPresented: $viewModel.showAddMemorySheet) {
            EditMemoryView()
        }
    }
    
    var filteredMemories: [Memory] {
        if searchText.isEmpty {
            return memories.availableMemories
        } else {
            return memories.availableMemories.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }


    private func toggleNotification(forMemory memory: Memory) {
        memories.toggleNotifications(for: memory)
    }

    private func markMemoryForDeletion(_ memory: Memory) {
        memories.markForDeletion(memory)

        if (neverDeletedAMemory) {
            //show notification
            neverDeletedAMemory = false
            showDeleteMemoryAlert = true

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

