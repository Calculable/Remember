import Foundation
import SwiftUI


/// Displays a graphical timeline with a list of events
struct TimelineView: View {
    
    @EnvironmentObject private var memories: Memories
    @State private var marginAmount = 1.0 //represents how much the memories are visually "spread" apart. In an older version of the app this value could be changed with a pinch-gesture. However it turned out that this feature was rather confusing. Therefore for now this value is just a constant
    
    var body: some View {
        NavigationView {
            //Slider(value: $marginAmount, in: 0...1).padding()
            ScrollView {
                VStack(spacing: 0.0) {
                    //Shows a list of memories that happened for each year.
                    let amountOfYears = amountOfYears()
                    let maxYear = memories.newestYear
                    if amountOfYears > 0 {
                        ForEach(0..<amountOfYears, id: \.self) { decrementYear in
                            //workaround to loop in reverse order
                            let currentYearToDisplay = maxYear! - decrementYear
                            TimelineYearView(marginFactor: 1.0, memories: memories.memoriesForYear(currentYearToDisplay), year: currentYearToDisplay).padding()
                        }
                    } else {
                        Text("No Memories to display")
                    }
                }
            }
            .navigationTitle("Timeline")
        }
        .navigationViewStyle(.stack)
    }
    
    ///Calculates how many years are shown in total in the timeline. This value depends on the years where the stored memories happened. 
    private func amountOfYears() -> Int {
        let minYear = memories.oldestYear
        let maxYear = memories.newestYear
        
        if let minYear = minYear, let maxYear = maxYear {
            let amountOfYears = (maxYear - minYear) + 1
            return amountOfYears
        } else {
            return 0
        }
    }
}
