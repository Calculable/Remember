import SwiftUI

/// Displays a list of memories
struct MemoriesListView: View {
    
    @Environment(\.accessibilityReduceTransparency) private var accessibilityReduceTransparency;
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @EnvironmentObject private var memories: Memories
    @StateObject private var viewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(memories.filteredMemories(searchText: viewModel.searchText)) { memory in
                    NavigationLink {
                        MemoryDetailView(memory: memory)
                    } label: {
                        MemoryListEntryView(memory: memory)
                            .swipeActions {
                                Button(role: .destructive) {
                                    viewModel.markMemoryForDeletion(memories: memories, memory: memory) //"deleted" memories can still be restored
                                } label: {
                                    Label("Delete", systemImage: "minus.circle")
                                }
                            }
                            .alert("Memory deleted", isPresented: $viewModel.showDeleteMemoryAlert) {
                                Button("OK", role: .cancel) {
                                }
                            } message: {
                                Text("Deleted Memories can be restored under Settings > Deleted Memories")
                            }
                    }
                    .swipeActions(edge: .leading) {
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
                    .listRowSeparatorTint(.gray)
                    .listStyle(.insetGrouped)
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search memory")
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
        //.phoneOnlyStackNavigationView()
        .sheet(isPresented: $viewModel.showAddMemorySheet) {
            EditMemoryView()
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

