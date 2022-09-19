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
                
                NavigationLink {
                    PrivacySettingsView()
                } label: {
                    Text("Privacy")
                }
                
                NavigationLink {
                    Form {
                                                    
                        Text("Warning: This step can not be undone")
                                .fixedSize(horizontal: false, vertical: true)
                                .font(.callout)
                        
                        Section {
                            Button("Remove all custom memories", role: .destructive) {
                                memories.removeAllMemories()
                            }
                        }
                        
                    }.navigationTitle("Reset").navigationBarTitleDisplayMode(.inline)

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

