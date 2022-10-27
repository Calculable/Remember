//
//  ContentView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    @AppStorage("biometric.authentication.enabled") private var enableBiometricAuthentication = false
    @StateObject private var memories: Memories = Memories()
    @State private var isUnlocked = false
    
    var upcomingMemoriesTab: some View {
        AnniversariesView()
            .tabItem {
                Label("Upcoming", systemImage: "flame")
            }
    }
    
    var memoriesListTab: some View {
        MemoriesListView()
            .tabItem {
                Label("Memories", systemImage: "list.bullet")
            }
    }
    
    var timelineTab: some View {
        TimelineView()
            .tabItem {
                Label("Timeline", systemImage: "calendar.day.timeline.left")
            }
    }
    
    var mapTab: some View {
        MapView()
            .tabItem {
                Label("Map", systemImage: "map")
            }
    }
    
    var settingsTab: some View {
        SettingsView()
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
    }
    
    var body: some View {
        VStack {
            if (enableBiometricAuthentication == false || isUnlocked == true) {
                TabView {
                    upcomingMemoriesTab
                    memoriesListTab
                    if (!voiceOverEnabled) { //Since the timeline view is created upon a canvas, it is not accessible unfortunately. ToDo: Replace with a better alternative.
                        timelineTab
                    }
                    mapTab
                    settingsTab
                }
                .environmentObject(memories)
            } else {
                LockView() {
                    authenticate()
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
                case .active: break
                case .inactive:
                    lock()
                case .background:
                    lock()
                @unknown default: print("Unknown")
            }
        }
    }
    
    private func authenticate() {
        AuthenticationHelper(isUnlocked: $isUnlocked, reason: "show your memories").authenticate()
    }
    
    private func lock() {
        isUnlocked = false
    }
}

class ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
    
    #if DEBUG
    @objc class func injected() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.windows.first?.rootViewController =
        UIHostingController(rootView: ContentView_Previews.previews)
    }
    #endif
}
