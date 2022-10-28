// Hmmm... Maybe choosing a canvas to draw the timeline was not my best idea. See documentation from apple: "Use a canvas to improve performance for a drawing that doesn’t primarily involve text or require interactive elements." Also, canvas is not accessible for voice over users. (https://developer.apple.com/documentation/swiftui/canvas)

import Foundation
import SwiftUI


/// Part of the TimelineView. Displays a graphical timeline for a list of events that happen in a specific year
struct TimelineYearView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    @StateObject private var viewModel: ViewModel
    
    init(memories: [Memory], year: Int, marginFactor: Binding<Double> = .constant(1.0)) {
        _viewModel = StateObject<ViewModel>(wrappedValue: ViewModel(memories: memories, year: year, marginFactor: marginFactor))
    }
    
    var body: some View {
        Canvas { context, size in
            viewModel.drawLine(size: size, context: context) //draws the timeline-view at the side of the screen
            viewModel.drawYear(context: context, size: size)
            var currentYPosition: Int = viewModel.marginToTopForTheFirstMemmory
            
            for i in 0..<viewModel.memories.count { //draw the title for each memory that happened in this year
                let currentMemory = viewModel.memories[i]
                currentYPosition += viewModel.marginTopToPreviousMemory(forMemoryAt: i)
                
                viewModel.drawMemoryIndicator(currentYPosition: currentYPosition, context: context, colorScheme: colorScheme)
                viewModel.drawMemoryTitle(currentMemory: currentMemory, context: context, currentYPosition: currentYPosition, size: size)
                
                currentYPosition += viewModel.marginYBetweenTitleAndYear
    
                viewModel.drawMemoryDate(currentMemory: currentMemory, context: context, currentYPosition: currentYPosition, colorScheme: colorScheme)
                
                currentYPosition += viewModel.minimalMarginYBetweenTwoMemories //do some specing so that events on the same day do not overlap
            }
        }
        .frame(height: viewModel.requiredHeight())
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
    }
}

struct TimelineYearView_Previews: PreviewProvider {
    static var previews: some View {
        let memories = Memories()
        let year = 2022
        return TimelineYearView(memories: memories.memoriesForYear(year), year: year, marginFactor: .constant(1.0))
            .environmentObject(memories)
    }
}
