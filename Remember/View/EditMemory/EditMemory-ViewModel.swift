//
//  AddMemory-ViewModel.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import SwiftUI
import MapKit


extension EditMemoryView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var isCustomCoordinate = false
        @Published var coordinate = CLLocationCoordinate2D(latitude: 46.818188, longitude: 8.227512)
        @Published var showingMapPicker = false
        @Published var name: String = ""
        @Published var date: Date = Date.now
        @Published var image: UIImage?
        @Published var notes: String = ""
        @Published var notificationsEnabled = false
        @Published var showingImagePicker = false
        @Published var existingMemory: Memory? = nil
        
        var onMemoryUpdated: ((Memory) -> Void)?


        var displayImage: Image? {
            guard let image = image else {
                return nil
            }
            
            return Image(uiImage: image)
        }
        
        init() {
            
        }
        
        
        
        init(_ memory: Memory? = nil, onMemoryUpdated: ((Memory) -> Void)? = nil) {
            
            
            if let memory = memory {
                if let memoryCoordinate = memory.coordinate {
                    isCustomCoordinate = true
                    coordinate = memoryCoordinate
                }

                self.name = memory.name
                self.date = memory.date
                self.image = memory.image
                self.notes = memory.notes
                self.notificationsEnabled = memory.notificationsEnabled
                self.existingMemory = memory
            }
            
            self.onMemoryUpdated = onMemoryUpdated

        }
                
        var saveDisabled:Bool {
            return name.isEmpty
        }
        
        func removeImage() {
            image = nil
        }
        
        func showImagePicker() {
            showingImagePicker = true
        }
        
        func showMapPicker() {
            showingMapPicker = true
        }
        
        func saveNewMemory(memories: Memories) {
            
            if let memory = existingMemory {
                memories.remove(memory)
            }
            
            let customCoordinate = isCustomCoordinate ? coordinate : nil
            let newMemory = Memory(name: name, date: date, image: image, coordinate: customCoordinate, notes: notes, notificationsEnabled: notificationsEnabled)
            memories.addMemory(newMemory)
            
            existingMemory = newMemory
            onMemoryUpdated?(newMemory)
            
        }
    }
}
