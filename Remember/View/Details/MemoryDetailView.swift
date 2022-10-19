//
//  MemoryDetailView.swift
//  Remember
//
//  Created by Jan Huber on 16.09.22.
//

import SwiftUI
import MapKit

struct MemoryDetailView: View {
    
    @State var memory: Memory
    
    @State private var mapRegion:MKCoordinateRegion
    @State var showEditMemorySheet = false
    @State private var showingDeleteAlert = false
    @EnvironmentObject var memories: Memories
    @State var isDeleted = false
    @AppStorage("neverDeletedAMemory") private var neverDeletedAMemory = true
    @State private var showDeleteMemoryAlert = false
    
    init(memory: Memory) {
        self._memory = State<Memory>(wrappedValue: memory)
        self._mapRegion =  State<MKCoordinateRegion>(wrappedValue: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: memory.coordinate?.latitude ?? 0, longitude: memory.coordinate?.longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)))
    }
    
        
    var body: some View {
        
        
        if (isDeleted) {
            Text("This memory was deleted")
        } else {
            
        
            ScrollView {
                
            
                VStack(alignment: .leading) {
                    Text(memory.name).font(.largeTitle)
                    Text(memory.date.formatted(date: .long, time: .omitted))
                        .foregroundColor(.secondary)
                    
                    if let image = memory.displayImage { //display image should not be in model
                        image.resizable().scaledToFit()
                            .frame(maxWidth: 700).clipped().padding([.bottom, .top], 20)
                    }


                    
                    Text(memory.notes)
                    

                    
                    
                    
                    
                    if memory.coordinate != nil {
                        Map(coordinateRegion: $mapRegion, annotationItems: [memory]) { memory in
                            MapMarker(coordinate: memory.coordinate!, tint: .background)
                        }.aspectRatio(2, contentMode: .fill)
                            .frame(minHeight: 300)
                            .padding()

                    }
                    
                        
                    if (memory.isMarkedForDeletion) {
                        Button("Restore") {
                            memories.restore(memory)
                        }.padding([.bottom, .top], 20)
                    } else {
                        
                    

                        Button("Delete", role: .destructive) {
                            showingDeleteAlert = true
                        }.padding([.bottom, .top], 20)
                        .alert("Delete Memory", isPresented: $showingDeleteAlert) {
                            Button("Delete", role: .destructive, action: {
                                memories.markForDeletion(memory)
                                isDeleted = true
                                
                                if (neverDeletedAMemory) {
                                    //show notification
                                    neverDeletedAMemory = false
                                    showDeleteMemoryAlert = true
                                    
                                }
                                
                            })
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("Are you sure?")
                        }.alert("Memory deleted", isPresented: $showDeleteMemoryAlert) {
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
                            showEditMemorySheet = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                    }
                }
                .sheet(isPresented: $showEditMemorySheet) {
                    EditMemoryView(toEdit: memory, onMemoryUpdated: { newMemory in
                        self.memory = newMemory //refresh view
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
