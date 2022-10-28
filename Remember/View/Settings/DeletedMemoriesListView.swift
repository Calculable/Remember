import SwiftUI


/// Displays a list of "deleted" memories. From here, the memories can either be restored or finally be deleted forever.
struct DeletedMemoriesListView: View {
    
    @Environment(\.accessibilityReduceTransparency) private var accessibilityReduceTransparency;
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @EnvironmentObject private var memories: Memories
    @State private var showDeleteConfirmationAlert = false
    
    var body: some View {
        Group {
            if !memories.memoriesMarkedForDeletion.isEmpty {
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
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                restore(memory)
                            } label: {
                                Label("Restore", systemImage: "gobackward")
                            }
                            .tint(.orange)
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
            } else {
                Text("No deleted memories")
            }
        }
        .toolbar {
            ToolbarItem() {
                Button {
                    displayDeleteConfirmationAlert()
                } label: {
                    Label("Delete Forever", systemImage: "xmark.bin.fill")
                }
                .disabled(memories.memoriesMarkedForDeletion.isEmpty)
                .alert("Delete Forever", isPresented: $showDeleteConfirmationAlert) {
                    Button("Delete", role: .destructive, action: {
                        deleteMarkedMemories() //This step cannot be undone. Finally deleted memories are deleted forever
                    })
                    Button("Cancel", role: .cancel) {
                    }
                } message: {
                    Text("Are you sure? Finally deleted memories cannot be restored anymore.")
                }
            }
        }
        .environment(\.defaultMinListRowHeight, 160)
        .navigationTitle("Deleted Memories")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func deleteMarkedMemories() {
        memories.deleteMarkedMemories()
    }
    
    private func displayDeleteConfirmationAlert() {
        showDeleteConfirmationAlert = true
    }
    
    private func restore(_ memory: Memory) {
        memories.restore(memory)
    }
}

struct DeletedMemoriesListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let memories = Memories()
        
        return DeletedMemoriesListView()
            .environmentObject(memories)
    }
}

