import Foundation


/// Contains helper functions for the "Settings"-Tab of the app
struct SettingsHelper {
    
    static func defaultNotificationTime() -> Date {
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        return Calendar.current.date(from: components)! //gibt ein Optional zurück
    }
}
