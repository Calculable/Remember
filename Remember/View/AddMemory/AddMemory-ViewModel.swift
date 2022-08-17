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
        @Published var image: Image?
        @Published var inputImage: UIImage?
        @Published var showingImagePicker = false
        
        var saveDisabled:Bool {
            return name.isEmpty
        }

        func loadImage() { //convert UI Image to image
            guard let inputImage = inputImage else { return }
            image = Image(uiImage: inputImage)
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
