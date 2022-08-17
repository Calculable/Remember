//
//  SettingsHelper.swift
//  Remember
//
//  Created by Jan Huber on 17.08.22.
//

import Foundation

struct SettingsHelper {
    static func getDefaultNotificationTime() -> Date {
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        return Calendar.current.date(from: components)! //gibt ein Optional zurück
        
    }
}
