//
//  MemoryDetailView-ViewModel.swift
//  Remember
//
//  Created by Jan Huber on 21.10.22.
//

import Foundation
import SwiftUI
import MapKit

extension MemoryDetailView {
    @MainActor class ViewModel: ObservableObject {
        
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
        
        func refreshView(withMemory memory: Memory) {
            self.memory = memory
        }
        
        func displayEditMemorySheet() {
            showEditMemorySheet = true
        }
        
        func markAsDeleted() {
            isDeleted = true
        }
        
        func markForDeletion(memories: Memories) {
            memories.markForDeletion(memory)
            markAsDeleted()
            
            if (neverDeletedAMemory) {
                //show notification
                showDeleteMemoryAlert = true
                
            }
    
            neverDeletedAMemory = false
            
        }
    }
}
