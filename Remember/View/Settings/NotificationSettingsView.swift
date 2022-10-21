//
//  NotificationSettingsView.swift
//  Remember
//
//  Created by Jan Huber on 17.08.22.
//

import SwiftUI


struct NotificationSettingsView: View {

    @StateObject private var viewModel = ViewModel()

    let availableNotificationDaysBeforeEvent = 0...7
    
    @EnvironmentObject var memories: Memories

    @AppStorage("notifications.days.before.event") private var selectedNotificationDaysBeforeEvent = 1
    @AppStorage("notification.time") private var timeOfNotifications = SettingsHelper.getDefaultNotificationTime()
    let notificationsHelper = NotificationHelper()
    
    func describeDaysBeforeEvent(_ daysBeforeEvent: Int) -> String {
        switch (daysBeforeEvent) {
        case 0:
            return String(localized: "On the same day")
        case 1:
            return String(localized: "1 day before the event")
        default:
            return String(format: NSLocalizedString("%d days before the event", comment: "number of days before the event"), daysBeforeEvent)

        }
    }
    
    var body: some View {
        
        
        
        Form {
            
            Text("Notifications can be triggered for the anniversaries of the memories. Under the Memories tab, notifications can be turned on or off individually for each memory.\n\nPlease make sure that the app has permission to send notifications (iOS Settings > Notifications).")
                .fixedSize(horizontal: false, vertical: true)
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
                }.onChange(of: selectedNotificationDaysBeforeEvent) { _ in
                            updateNotifications()
                }
                
            }
            
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func updateNotifications() {
        notificationsHelper.updateNotifications(memories: memories)
    }

}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}

