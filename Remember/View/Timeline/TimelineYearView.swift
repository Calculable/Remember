// Hmmm... Maybe choosing a canvas to draw the timeline was not my best idea. See documentation from apple: "Use a canvas to improve performance for a drawing that doesn’t primarily involve text or require interactive elements." Also, canvas is not accessible for voice over users. (https://developer.apple.com/documentation/swiftui/canvas)

import Foundation
import SwiftUI


/// Part of the TimelineView. Displays a graphical timeline for a list of events that happen in a specific year
struct TimelineYearView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    var marginFactor: Double
    var memories: [Memory]
    var year: Int
    
    private let marginXYear = 30
    private let marginXMemory = 30
    let minimalMarginYBetweenTwoMemories = 50
    let marginYBetweenTitleAndYear  = 30
    let marginToTopForTheFirstMemmory = 50


    
    var body: some View {
        Canvas { context, size in
            drawLine(size: size, context: context) //draws the timeline-view at the side of the screen
            drawYear(context: context, size: size)
            var currentYPosition: Int = marginToTopForTheFirstMemmory
            
            for i in 0..<memories.count { //draw the title for each memory that happened in this year
                let currentMemory = memories[i]
                currentYPosition += marginTopToPreviousMemory(forMemoryAt: i)
                
                drawMemoryIndicator(currentYPosition: currentYPosition, context: context, colorScheme: colorScheme)
                drawMemoryTitle(currentMemory: currentMemory, context: context, currentYPosition: currentYPosition, size: size)
                
                currentYPosition += marginYBetweenTitleAndYear
    
                drawMemoryDate(currentMemory: currentMemory, context: context, currentYPosition: currentYPosition, colorScheme: colorScheme)
                
                currentYPosition += minimalMarginYBetweenTwoMemories //do some specing so that events on the same day do not overlap
            }
        }
        .frame(height: requiredHeight())
        .dynamicTypeSize(...DynamicTypeSize.xxLarge)
    }
    
    func drawMemoryDate(currentMemory: Memory, context: GraphicsContext, currentYPosition: Int, colorScheme: ColorScheme) {
        let dateToDraw =
        Text("\(currentMemory.date.formatted(date: .long, time: .omitted))")
            .font(.title3)
            .foregroundColor(colorScheme == .dark ? .lightBackground : .background)
        context.draw(dateToDraw, at: CGPoint(x: marginXMemory, y: currentYPosition), anchor: .topLeading)
    }
    
    func drawMemoryTitle(currentMemory: Memory, context: GraphicsContext, currentYPosition: Int, size: CGSize) {
        let textToDraw = Text("\(currentMemory.name)")
            .font(.title3)
            .fontWeight(.bold)
        context.draw(textToDraw, in: CGRect(x: marginXMemory, y: currentYPosition, width: Int(size.width - 50), height: 30))
    }
    
    func drawMemoryIndicator(currentYPosition: Int, context: GraphicsContext, colorScheme: ColorScheme) {
        var p = Path()
        p.move(to: CGPoint(x: 100, y: 100))
        let rect = CGRect(x: 0, y: currentYPosition + 9, width: 10, height: 10)
        p.addRect(rect)
        context.stroke(p, with: .color(colorScheme == .dark ? .lightBackground : .background), lineWidth: 10)
    }
    
    func drawYear(context: GraphicsContext, size: CGSize) {
        let textToDraw: Text = Text("\(String(year))").font(.title)
        context.draw(textToDraw, at: CGPoint(x: size.width - CGFloat(marginXYear), y: 0), anchor: .topTrailing)
    }
    
    func drawLine(size: CGSize, context: GraphicsContext) {
        var linePath = Path()
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: 0, y: size.height))
        context.stroke(linePath, with: .color(.background), lineWidth: 10)
    }
    
    ///Calculates the height that is required to render the TimelineYearView in a proper manner.
    func requiredHeight() -> CGFloat {
        var totalHeight = 0
        totalHeight += marginToTopForTheFirstMemmory
        
        for i in 0..<memories.count {
            totalHeight += marginTopToPreviousMemory(forMemoryAt: i)
        }
        
        if (memories.count >= 1) {
            totalHeight += marginBottomToNextMemory(forMemoryAt: memories.count - 1)
        }
        
        totalHeight += (minimalMarginYBetweenTwoMemories + marginYBetweenTitleAndYear) * memories.count
        return CGFloat(totalHeight)
    }
    
    func marginTopToPreviousMemory(forMemoryAt index: Int) -> Int {
        let currentMemory = memories[index]
        let comparisonDate = index == 0 ? Date.lastDayOfYear(year: year) : memories[index - 1].date
        let daysBetweenMemoryAndLastMemory = currentMemory.date.timeIntervalInDays(to: comparisonDate)
        let marginToPreviousMemory = Double(daysBetweenMemoryAndLastMemory) * marginFactor
        return Int(ceil(marginToPreviousMemory))
    }
    
    func marginBottomToNextMemory(forMemoryAt index: Int) -> Int {
        let currentMemory = memories[index]
        let comparisonDate = index == memories.count - 1 ? Date.firstDayOfYear(year: year) : memories[index + 1].date
        let daysBetweenMemoryAndNextMemory = currentMemory.date.timeIntervalInDays(to: comparisonDate)
        let marginToNextMemory = Double(daysBetweenMemoryAndNextMemory) * marginFactor
        return Int(ceil(marginToNextMemory))
    }
}

struct TimelineYearView_Previews: PreviewProvider {
    static var previews: some View {
        let memories = Memories()
        let year = 2022
                
        return TimelineYearView(marginFactor: 1.0, memories: memories.memoriesForYear(year), year: year)
            .environmentObject(memories)
    }
}
