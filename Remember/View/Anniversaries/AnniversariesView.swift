import SwiftUI
import Foundation

/// Displays a list of upcoming anniversaries (= memories that occures exactely 1, 2, 3... years ago or a special number of days ago, for example 1000 days)
struct AnniversariesView: View {
    
    @EnvironmentObject private var memories: Memories
    @StateObject private var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.filteredAnniversaries(memories: memories)) { anniversary in
                        NavigationLink {
                            MemoryDetailView(memory: anniversary.memory)
                        } label: {
                            AnniversaryListEntryView(anniversary: anniversary, isScreenshot: false)
                        }
                    }
                }
                .navigationTitle("Upcoming")
            }
            .searchable(text: $viewModel.searchText, prompt: "Search upcoming memory") //show search bar
            
            Text("Please select an upcoming memory to see the details")
        }
        .phoneOnlyStackNavigationView()
    }
}

struct UpcomingMemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let memories = Memories()
        return AnniversariesView()
            .environmentObject(memories)
    }
}

