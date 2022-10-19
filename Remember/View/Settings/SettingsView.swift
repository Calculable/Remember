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
                
                /*NavigationLink {
                    PrivacySettingsView()
                } label: {
                    Text("Privacy")
                }*/
                
                NavigationLink {
                    DeletedMemoriesListView()
                } label: {
                    Text("Deleted Memories").badge(memories.memoriesMarkedForDeletion.count)
                }
                
                NavigationLink {
                    ResetMemoriesView()
                } label: {
                    Text("Reset")
                }
                

                
                
            }
            .navigationTitle("Settings")
                        
        }.navigationViewStyle(.stack)
        
        
    }

    
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

