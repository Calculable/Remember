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

    
    
    var filteredUpcomingSpecialDays: [UpcomingSpecialDay] {
        let upcomingSpecialDays = viewModel.generateUpcomingSpecialDays(memories: memories)
        
        if searchText.isEmpty {
            return upcomingSpecialDays
        } else {
            return upcomingSpecialDays.filter { $0.memory.name.localizedCaseInsensitiveContains(searchText) }
        }
        
        
    }
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack {
                    ForEach(filteredUpcomingSpecialDays) { specialDay in
                        NavigationLink {
                            MemoryDetailView(memory: specialDay.memory)
                        } label: {
                            UpcomingMemoryListEntryView(specialDay: specialDay, isScreenshot: false)
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

