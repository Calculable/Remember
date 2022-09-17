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
    
    var upcomingSpecialDays: [UpcomingSpecialDay] {
        return viewModel.generateUpcomingSpecialDays(memories: memories)
    }
    
    var body: some View {
        
        NavigationView {
                List {
                    ForEach(upcomingSpecialDays) { specialDay in
                        NavigationLink {
                            MemoryDetailView(memory: specialDay.memory)
                        } label: {
                            UpcomingMemoryListEntryView(specialDay: specialDay)
                        }
                    }
                }
                .navigationTitle("Upcoming")
            
            Text("Please select an upcoming special day to see the details")
                
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

