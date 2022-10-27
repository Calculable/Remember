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
}
