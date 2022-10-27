import SwiftUI
import Foundation

struct AnniversariesView: View {
    
    @EnvironmentObject private var memories: Memories
    @StateObject private var viewModel: ViewModel = ViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
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
            .searchable(text: $viewModel.searchText, prompt: "Search upcoming memory")
            
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

