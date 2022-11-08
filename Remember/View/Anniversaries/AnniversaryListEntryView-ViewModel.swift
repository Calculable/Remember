import Foundation
import SwiftUI

extension AnniversaryListEntryView {
    
    /// The view model for the AnniversaryListEntryView
    @MainActor class ViewModel: ObservableObject {
        @Published private(set) var anniversary: Anniversary
        @Published var showImageSavedNotification = false
        @Published var showImageSaveErrorNotification = false
        @Published private(set) var uiImage: UIImage? = nil
        @Published private(set) var isScreenshot: Bool //By clicking on "Share", a user can take a "screenshot" of this AnniversaryListEntryView. The screenshot-version of the view is a little bit different visually (for example the "Share"-Button itself gets hidden)
        
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
        
        /// A text to describe the amount of days until an anniversary in natural language
        func timeIntervalDescription(anniversary: Anniversary) -> String {
            switch (anniversary.type) {
            case .year where anniversary.years >= 0:
                return String(format: NSLocalizedString("%d years since", comment: "number of days since the memory"), anniversary.years)
            case .year where anniversary.years < 0:
                return String(format: NSLocalizedString("%d years until", comment: "number of days since the memory"), abs(anniversary.years))
            case .day where anniversary.days >= 0:
                return String(format: NSLocalizedString("%d days since", comment: "number of days since the memory"), anniversary.days)
            case .day where anniversary.days < 0:
                return String(format: NSLocalizedString("%d days until", comment: "number of days since the memory"), abs(anniversary.days))
            default:
                return "unknown anniversary type"
            }
        }
        
        func remainingDays(to date: Date) -> Int {
            Calendar.current.today().timeIntervalInDays(to: date)
        }
        
        /// A text to describe the amount of days until a date in natural language
        func describeRemainingDays(until date: Date) -> String {
            let numberOfRemainingDays = remainingDays(to: date)
            
            switch (numberOfRemainingDays) {
            case 0:
                return String(localized: "Today")
            case 1:
                return String(localized: "Tomorrow")
            default:
                return String(format: NSLocalizedString("In %d days, on", comment: "number of days remaining days"), numberOfRemainingDays)
                
            }
        }
    }
}
