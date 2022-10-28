import Foundation
import SwiftUI

extension AnniversaryListEntryView {
    
    /// The view model for the AnniversaryListEntryView
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var anniversary: Anniversary
        @Published var showImageSavedNotification = false
        @Published var showImageSaveErrorNotification = false
        @Published private(set) var uiImage: UIImage? = nil
        @Published private(set) var isScreenshot: Bool
        
        init(anniversary: Anniversary, isScreenshot: Bool = false) {
            self.anniversary = anniversary
            self.isScreenshot = isScreenshot
        }
        
        func shareMemoryImage() {
            let view = AnniversaryListEntryView(anniversary: anniversary, isScreenshot: true)
            
            let image = view.snapshot(width: 500, height: 500)
            
            let imageSaver = ImageSaver()
            imageSaver.errorHandler = { _ in
                self.showImageSaveErrorNotification = true
            }
            
            imageSaver.successHandler = {
                self.showImageSavedNotification = true
            }
            
            imageSaver.writeToPhotoAlbum(image: image)
        }
        
        func timeIntervalDescription(anniversary: Anniversary) -> String {
            switch (anniversary.type) {
            case .year:
                return String(format: NSLocalizedString("%d years since", comment: "number of days since the anniversary"), anniversary.years)
                
            case .day:
                return String(format: NSLocalizedString("%d days since", comment: "number of days since the anniversary"), anniversary.days)
            }
        }
        
        func remainingDays(to date: Date) -> Int {
            Calendar.current.today().timeIntervalInDays(to: date)
        }
        
        func describeRemainingDays(until date: Date) -> String {
            let numberOfRemainingDays = remainingDays(to: date)
            
            switch (numberOfRemainingDays) {
            case 0:
                return String(localized: "Today")
            case 1:
                return String(localized: "Tomorrow")
            default:
                return String(format: NSLocalizedString("In %d days", comment: "number of days remaining days"), numberOfRemainingDays)
                
            }
        }
    }
}
