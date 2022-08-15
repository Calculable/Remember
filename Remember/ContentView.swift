//
//  ContentView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct ContentView: View {
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

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
