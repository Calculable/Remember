import Foundation
import UIKit
import SwiftUI
import PhotosUI

//modified source: https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-phpickerviewcontroller

/// Makes the image picker available for Swift UI
struct ImagePicker: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = PHPickerViewController
    @Binding var image: UIImage? //the image that was picked
    var onError: (() -> ())?
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images //only photos, no live images or vidoes
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        //body not needed
    }
    
    func makeCoordinator() -> Coordinator { //diese Methode wird automatisch von SwiftUI aufgerufen.!!!
        Coordinator(self)
    }
}
