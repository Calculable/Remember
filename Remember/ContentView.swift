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
            Text("Upcoming")
                .tabItem {
                    Label("upcoming", systemImage: "flame")
                }
            
            Text("Memories")
                .tabItem {
                    Label("memories", systemImage: "list.bullet")
                }

            Text("Settings")
                .tabItem {
                    Label("settings", systemImage: "gear")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
