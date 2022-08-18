//
//  ImagePicker.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import Foundation
import UIKit
import SwiftUI
import PhotosUI

//modified source: https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-phpickerviewcontroller

struct ImagePicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController
    @Binding var image: UIImage?

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images //only photos, no live images or vidoes
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
       //not needed
    }
    
    func makeCoordinator() -> Coordinator { //diese Methode wird automatisch von SwiftUI aufgerufen.!!!
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            // Exit if no selection was made
            guard let provider = results.first?.itemProvider else { return }
            
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
