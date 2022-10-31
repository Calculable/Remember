//Source from this page: https://capps.tech/blog/read-files-with-documentpicker-in-swiftui

import Foundation
import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable{
    @Binding var fileContent: String
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(fileContent: $fileContent)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController{
            let controller: UIDocumentPickerViewController
            controller=UIDocumentPickerViewController(forOpeningContentTypes:[.text], asCopy: true)
        controller.delegate = context.coordinator
            return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context:UIViewControllerRepresentableContext<DocumentPicker>){}
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    @Binding var fileContent: String
    
    init(fileContent: Binding<String>){
        _fileContent = fileContent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let fileUrl = urls[0]
        do {
            fileContent = try String(contentsOf: fileUrl, encoding: .utf8)
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
}
