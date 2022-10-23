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

    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(viewModel.filteredAnniversaries(memories: memories)) { anniversary in
                        NavigationLink {
                            MemoryDetailView(memory: anniversary.memory)
                        } label: {
                            UpcomingMemoryListEntryView(anniversary: anniversary, isScreenshot: false)
                        }
                    }
                }
                .navigationTitle("Upcoming")
            
            }.searchable(text: $viewModel.searchText, prompt: "Search upcoming memory")

            
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

