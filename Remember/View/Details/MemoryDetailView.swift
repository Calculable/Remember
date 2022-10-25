//
//  MemoryDetailView.swift
//  Remember
//
//  Created by Jan Huber on 16.09.22.
//

import SwiftUI
import MapKit

struct MemoryDetailView: View {

    @EnvironmentObject var memories: Memories
    @StateObject private var viewModel: ViewModel

    init(memory: Memory) {
        self._viewModel = StateObject<ViewModel>(wrappedValue: ViewModel(memory: memory))
    }
    
    var body: some View {
        
        
        if (viewModel.isDeleted) {
            Text("This memory was deleted")
        } else {
            
        
            ScrollView {
                
                VStack(alignment: .leading) {
                    
                    Text(viewModel.memory.name).font(.largeTitle)
                    Text(viewModel.memory.date.formatted(date: .long, time: .omitted))
                        .foregroundColor(.secondary)
                    
                    if let image = viewModel.memory.image { //display image should not be in model
                        Image(uiImage: image).resizable().scaledToFit()
                            .frame(maxWidth: 700).clipped().padding([.bottom, .top], 20)
                    }


                    
                    Text(viewModel.memory.notes)
                    

                    
                    
                    
                    
                    if viewModel.memory.coordinate != nil {
                        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: [viewModel.memory]) { memory in
                            MapMarker(coordinate: memory.coordinate!, tint: .background)
                        }.aspectRatio(2, contentMode: .fill)
                            .frame(minHeight: 300)
                            .padding()

                    }
                    
                        
                    if (viewModel.memory.isMarkedForDeletion) {
                        Button("Restore") {
                            memories.restore(viewModel.memory)
                        }.padding([.bottom, .top], 20)
                    } else {
                        
                    

                        Button("Delete", role: .destructive) {
                            viewModel.displayDeleteAlert()
                        }.padding([.bottom, .top], 20)
                        .alert("Delete Memory", isPresented: $viewModel.showingDeleteAlert) {
                            Button("Delete", role: .destructive, action: {
                                viewModel.markForDeletion(memories: memories)
                            })
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Are you sure?")
                        }.alert("Memory deleted", isPresented: $viewModel.showDeleteMemoryAlert) {
                            Button("OK", role: .cancel) { }
                        } message: {
                            Text("Deleted Memories can be restored under Settings > Deleted Memories")
                        }
                    
                    }
                    
                }.padding()
                
            
                
            }.navigationTitle("Details")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem() {
                        Button {
                            viewModel.displayEditMemorySheet()
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
                .sheet(isPresented: $viewModel.showEditMemorySheet) {
                    EditMemoryView(toEdit: viewModel.memory, onMemoryUpdated: { newMemory in
                        viewModel.refreshView(withMemory: newMemory) //refresh view
                    })
                }
        }
    }
    


}

struct MemoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let memory = Memory(name: "Moonlanding", date: Date(day: 16, month: 7, year: 1969), image: UIImage(named:"moon"), coordinate: CLLocationCoordinate2D(latitude: 47.35296, longitude: 8.78047), notificationsEnabled: false)
        
        MemoryDetailView(memory: memory)
    }
}
