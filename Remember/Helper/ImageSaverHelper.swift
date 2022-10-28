//source: This class was partially copied from the 100 days of swift course

import Foundation
import SwiftUI


/// Saves images to the user's photo library
class ImageSaver: NSObject {
    
    var successHandler: (() -> Void)?
    var errorHandler: ((Error) -> Void)?
    
    /// Stores a picture in the user's photo library. Calls the successHandler if the image was saved successfully and the errorHandler if the image could not be saved for various reson (for example: the user didn't give the app the permission to store images)
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }
    
    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            errorHandler?(error)
        } else {
            successHandler?()
        }
    }
}
