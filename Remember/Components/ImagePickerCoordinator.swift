//
//  ImagePickerCoordinator.swift
//  Remember
//
//  Created by Jan Huber on 25.10.22.
//

//modified source: https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-phpickerviewcontroller

import Foundation
import UIKit
import SwiftUI
import PhotosUI

extension ImagePicker {
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            // Exit if no selection was made
            guard let provider = results.first?.itemProvider else {
                return
            }
            
            // If this has an image we can use, use it
            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { image, _ in
                    Task { @MainActor in
                        self.parent.image = image as? UIImage
                    }
                }
            }
        }
    }
}
