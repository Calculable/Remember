//
//  NotificationSettingsView.swift
//  Remember
//
//  Created by Jan Huber on 17.08.22.
//

import SwiftUI


struct NotificationSettingsView: View {
    
    let availableNotificationDaysBeforeEvent = 0...7
    
    @EnvironmentObject var memories: Memories

    @AppStorage("notifications.days.before.event") private var selectedNotificationDaysBeforeEvent = 1
    @AppStorage("notification.time") private var timeOfNotifications = SettingsHelper.getDefaultNotificationTime()
    let notificationsHelper = NotificationHelper()
    
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
                    .onChange(of: timeOfNotifications) { _ in
                        notificationsHelper.updateNotifications(memories: memories)
                    }
                Picker("Days before event", selection: $selectedNotificationDaysBeforeEvent) {
                    ForEach(availableNotificationDaysBeforeEvent, id: \.self) {
                        Text(describeDaysBeforeEvent($0))
                    }
                }.onChange(of: selectedNotificationDaysBeforeEvent) { newValue in
                    notificationsHelper.updateNotifications(memories: memories)
                }
                
            }
            
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}
