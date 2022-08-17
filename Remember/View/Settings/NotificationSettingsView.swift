//
//  NotificationSettingsView.swift
//  Remember
//
//  Created by Jan Huber on 17.08.22.
//

import SwiftUI

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

struct NotificationSettingsView: View {
    
    let availableNotificationDaysBeforeEvent = 0...7
    
    @AppStorage("notifications.days.before.event") private var selectedNotificationDaysBeforeEvent = 0
    @AppStorage("notification.time") private var timeOfNotifications = getDefaultNotificationTime()
    
    
    
    func describeDaysBeforeEvent(_ daysBeforeEvent: Int) -> String {
        switch (daysBeforeEvent) {
        case 0:
            return "On the same day"
        case 1:
            return "1 day before the event"
        default:
            return "\(daysBeforeEvent) days before the event"
        }
        
        
    }
    
    var body: some View {
        
        
        
        Form {
            
            Text("Notifications can be triggered for the anniversaries of the memories. Under the Memories tab, notifications can be turned on or off individually for each memory.\n\nPlease make sure that the app has permission to send notifications (iOS Settings > Notifications).")
                .font(.callout)
            
            
            Section {
                
                
                DatePicker("Time of notifications", selection: $timeOfNotifications, displayedComponents: .hourAndMinute)
                Picker("Days before event", selection: $selectedNotificationDaysBeforeEvent) {
                    ForEach(availableNotificationDaysBeforeEvent, id: \.self) {
                        Text(describeDaysBeforeEvent($0))
                    }
                }
                
            }
            
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    static func getDefaultNotificationTime() -> Date {
        var components = DateComponents()
        components.hour = 9
        components.minute = 0
        return Calendar.current.date(from: components)! //gibt ein Optional zurück
        
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}

