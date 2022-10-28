import SwiftUI


/// Displays the notification settings
struct NotificationSettingsView: View {
    
    @EnvironmentObject private var memories: Memories
    
    /// describes how many days before an anniversary a local notification should be triggeret
    @AppStorage("notifications.days.before.anniversary") private var selectedNotificationDaysBeforeAnniversary = 1
    
    /// describes at which time of the day notifications should be triggeret
    @AppStorage("notification.time") private var timeOfNotifications = SettingsHelper.defaultNotificationTime()
    
    private let notificationsHelper = NotificationHelper()
    
    private let availableNotificationDaysBeforeAnniversary = 0...7 //available options in the user interface
    
    var body: some View {
        Form {
            
            Text("Notifications can be triggered for the anniversaries of the memories. Under the Memories tab, notifications can be turned on or off individually for each memory.\n\nPlease make sure that the app has permission to send notifications (iOS Settings > Notifications).")
                .fixedSize(horizontal: false, vertical: true)
                .font(.callout)
            
            Section {
                DatePicker("Time of notifications", selection: $timeOfNotifications, displayedComponents: .hourAndMinute)
                    .onChange(of: timeOfNotifications) { _ in
                        notificationsHelper.updateNotifications(forMemories: memories)
                    }
                Picker("Days before event", selection: $selectedNotificationDaysBeforeAnniversary) {
                    ForEach(availableNotificationDaysBeforeAnniversary, id: \.self) {
                        Text(describeDaysBeforeEvent($0))
                    }
                }
                .onChange(of: selectedNotificationDaysBeforeAnniversary) { _ in
                    notificationsHelper.updateNotifications(forMemories: memories)
                }
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func describeDaysBeforeEvent(_ daysBeforeEvent: Int) -> String {
        switch (daysBeforeEvent) {
        case 0:
            return String(localized: "On the same day")
        case 1:
            return String(localized: "1 day before the event")
        default:
            return String(format: NSLocalizedString("%d days before the event", comment: "number of days before the event"), daysBeforeEvent)
            
        }
    }
}

struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView()
    }
}

