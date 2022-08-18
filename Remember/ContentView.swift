//
//  ContentView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var memories: Memories = Memories()
    
    var body: some View {
        TabView {
            UpcomingMemoriesView()
                .tabItem {
                    Label("Upcoming", systemImage: "flame")
                }
            
            MemoriesListView()
                .tabItem {
                    Label("Memories", systemImage: "list.bullet")
                }

            TimelineView()
                .tabItem {
                    Label("Timeline", systemImage: "calendar.day.timeline.left")
                }

            
            
            
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }.environmentObject(memories)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
