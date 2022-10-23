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

        var displayImage: Image? {
            guard let image = image else {
                return nil
            }
            
            return Image(uiImage: image)
        }
        
        init() {
            
        }
        
        init(_ memory: Memory) {
            if let memoryCoordinate = memory.coordinate {
                isCustomCoordinate = true
                coordinate = memoryCoordinate
            }

            name = memory.name
            date = memory.date
            image = memory.image
            notes = memory.notes
            notificationsEnabled = memory.notificationsEnabled
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
    }
}
