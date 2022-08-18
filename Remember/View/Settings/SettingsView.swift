//
//  SettingsView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct SettingsView: View {

    @EnvironmentObject var memories: Memories

    var body: some View {
        
        NavigationView {
            List {
                
                NavigationLink {
                    NotificationSettingsView()
                    
                } label: {
                    Text("Notifications")
                }
                
                Button("Remove all custom memories", role: .destructive) {
                    memories.removeAllMemories()
                }
                
                
            }
            .navigationTitle("Settings")
        }
        
        
    }

    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

