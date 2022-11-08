import Foundation
import SwiftUI
import MapKit

extension MemoryDetailView {
    
    /// The ViewModel for MemoryDetailView
    @MainActor class ViewModel: ObservableObject {
        
        
        /// Stores if the user cas ever delted a memory. If the user has never deleted a memory, a notification can be shown when a memory is deleted for the first time
        @AppStorage("neverDeletedAMemory") var neverDeletedAMemory = true
        @Published private(set) var memory: Memory
        @Published var mapRegion: MKCoordinateRegion
        @Published var showEditMemorySheet = false
        @Published var showingDeleteAlert = false
        @Published private(set) var isDeleted = false
        @Published var showDeleteMemoryAlert = false
        
        init(memory: Memory) {
            self.memory = memory
            self.mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: memory.coordinate?.latitude ?? 0, longitude: memory.coordinate?.longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
        
        func displayDeleteAlert() {
            showingDeleteAlert = true
        }
        
        func updateMapRegion() {
            self.mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: memory.coordinate?.latitude ?? 0, longitude: memory.coordinate?.longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        }
        
        func displayEditMemorySheet() {
            showEditMemorySheet = true
        }
        
        func markAsDeleted() {
            isDeleted = true
        }
        
        ///a memory that is marked for delection can still be restored
        func markForDeletion(memories: Memories) {
            memories.markForDeletion(memory)
            markAsDeleted() //don't show the details of this memory anymore
            
            if (neverDeletedAMemory) {
                //show notification if the user has never delted a memory before
                showDeleteMemoryAlert = true
                
            }
            neverDeletedAMemory = false
        }
    }
}
