//
//  NotificationSettingsView.swift
//  Remember
//
//  Created by Jan Huber on 17.08.22.
//

import SwiftUI


struct NotificationSettingsView: View {

    @StateObject private var viewModel = ViewModel()
    
    @EnvironmentObject var memories: Memories

    @AppStorage("notifications.days.before.event") private var selectedNotificationDaysBeforeEvent = 1
    @AppStorage("notification.time") private var timeOfNotifications = SettingsHelper.getDefaultNotificationTime()
    
    
    
    var body: some View {
        
        
        
        Form {
            
            Text("Notifications can be triggered for the anniversaries of the memories. Under the Memories tab, notifications can be turned on or off individually for each memory.\n\nPlease make sure that the app has permission to send notifications (iOS Settings > Notifications).")
                .fixedSize(horizontal: false, vertical: true)
                .font(.callout)
            
            
            Section {
                
                
                DatePicker("Time of notifications", selection: $timeOfNotifications, displayedComponents: .hourAndMinute)
                    .onChange(of: timeOfNotifications) { _ in
                        viewModel.notificationsHelper.updateNotifications(memories: memories)
                    }
                Picker("Days before event", selection: $selectedNotificationDaysBeforeEvent) {
                    ForEach(viewModel.availableNotificationDaysBeforeEvent, id: \.self) {
                        Text(viewModel.describeDaysBeforeEvent($0))
                    }
                }.onChange(of: selectedNotificationDaysBeforeEvent) { _ in
                    viewModel.notificationsHelper.updateNotifications(memories: memories)
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

