//
//  UpcomingMemoriesView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI
import Foundation

struct UpcomingMemoriesView: View {
    
    @StateObject private var viewModel: ViewModel = ViewModel()
    @EnvironmentObject var memories: Memories
    @State private var searchText = ""

    
    
    var filteredAnniversaries: [Anniversary] {
        let Anniversaries = viewModel.generateAnniversaries(memories: memories)
        
        if searchText.isEmpty {
            return Anniversaries
        } else {
            return Anniversaries.filter { $0.memory.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        
    }
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(filteredAnniversaries) { anniversary in
                        NavigationLink {
                            MemoryDetailView(memory: anniversary.memory)
                        } label: {
                            UpcomingMemoryListEntryView(anniversary: anniversary, isScreenshot: false)
                        }
                    }
                }
                .navigationTitle("Upcoming")
            
            }.searchable(text: $searchText, prompt: "Search upcoming memory")

            
            Text("Please select an upcoming memory to see the details")
        }.phoneOnlyStackNavigationView()
    }
    
    
    
}

struct UpcomingMemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let memories = Memories()
        return UpcomingMemoriesView()
            .environmentObject(memories)
    }
}

