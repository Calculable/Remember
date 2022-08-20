//
//  ContentView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var memories: Memories = Memories()
    @AppStorage("biometric.authentication.enabled") private var enableBiometricAuthentication = false
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    
    @State private var isUnlocked = false

    var body: some View {
        
        VStack {
            
        
            if (enableBiometricAuthentication == false || isUnlocked == true) {
            
                TabView {
                    UpcomingMemoriesView()
                        .tabItem {
                            Label("Upcoming", systemImage: "flame")
                        }
                    
                    MemoriesListView()
                        .tabItem {
                            Label("Memories", systemImage: "list.bullet")
                        }

                    if (!voiceOverEnabled) { //Since the timeline view is created upon a canvas, it is not accessible unfortunately. ToDo: Replace with a better alternative.
                        TimelineView()
                            .tabItem {
                                Label("Timeline", systemImage: "calendar.day.timeline.left")
                            }
                    }

                    
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gear")
                        }
                    
                    
                }
                .environmentObject(memories)
                
            } else {
                LockView() {
                    authenticate()
                }
            }
            
        }.onChange(of: scenePhase) { newPhase in
            
            switch newPhase {
                case .active : break
                case .inactive:
                    lock()
                case .background:
                    lock()
                        
                @unknown default: print("Unknown")
            }

        }

    }
    
    func authenticate() {
        AuthenticationHelper(isUnlocked: $isUnlocked).authenticate()
    }
    
    func lock() {
        isUnlocked = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
