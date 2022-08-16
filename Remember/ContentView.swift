//
//  ContentView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var model: Memories = Memories()
    
    var body: some View {
        TabView {
            UpcomingMemoriesView(model: model)
                .tabItem {
                    Label("Upcoming", systemImage: "flame")
                }
            
            MemoriesListView(model: model)
                .tabItem {
                    Label("Memories", systemImage: "list.bullet")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }.onAppear {
            model.loadExampleMemories()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
