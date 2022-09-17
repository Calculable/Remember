//
//  AddMemory-ViewModel.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import SwiftUI
import MapKit


extension AddMemoryView {
    @MainActor class ViewModel: ObservableObject {
        
        @Published var isCustomCoordinate = false
        @Published var coordinate = CLLocationCoordinate2D(latitude: 46.818188, longitude: 8.227512)
        @Published var showingMapPicker = false
        @Published var name: String = ""
        @Published var date: Date = Date.now
        @Published var image: UIImage?
        @Published var notes: String = ""
        
        var displayImage: Image? {
            guard let image = image else {
                return nil
            }
            
            return Image(uiImage: image)
        }
        
        @Published var showingImagePicker = false
        
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
