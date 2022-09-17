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

    let notificationHelper = NotificationHelper()
    
    var body: some View {
        
        NavigationView {
                List {
                    ForEach(memories.memories) { memory in
                        
                        NavigationLink {
                            MemoryDetailView(memory: memory)
                        } label: {
                            
                            MemoryListEntryView(memory: memory)
                                .swipeActions {
                                    Button(role: .destructive) {
                                        notificationHelper.removeNotification(for: memory)
                                        memories.remove(memory)
                                    
                                    } label: {
                                        Label("Delete", systemImage: "minus.circle")
                                    }
                                }
                                .swipeActions(edge: .leading) {
                                    Button {
                                        memories.toggleNotifications(for: memory)
                                        notificationHelper.updateNotification(for: memory)

                                    } label: {
                                        if memory.notificationsEnabled {
                                            Label("Disable Notifications", systemImage: "bell.slash")
                                        } else {
                                            Label("Enable Notifications", systemImage: "bell")
                                        }
                                        
                                    }
                                    .tint(memory.notificationsEnabled ? .gray : .purple)
                                }
                        }
                    }
                }
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

