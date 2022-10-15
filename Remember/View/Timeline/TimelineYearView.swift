//
//  TimelineYearView.swift
//  Remember
//
//  Created by Jan Huber on 18.08.22.
//

// Hmmm... Maybe choosing a canvas to draw the timeline was not my best idea. See documentation from apple: "Use a canvas to improve performance for a drawing that doesn’t primarily involve text or require interactive elements." Also, canvas is not accessible for voice over users. (https://developer.apple.com/documentation/swiftui/canvas)


import Foundation

import SwiftUI

struct TimelineYearView: View {
    
    @Environment(\.colorScheme) var colorScheme

    
    var memories: [Memory]
    var year: Int
    
    
    @Binding var marginFactor: Double
    
    @State private var marginXYear = 30
    @State private var marginXMemory = 30
    @State private var minimalMarginYBetweenTwoMemories = 50
    @State private var marginYBetweenTitleAndYear = 30

    @State private var marginToTopForTheFirstMemmory = 50
    
    var body: some View {
                    
        
            Canvas { context, size in

                
                var linePath = Path()
                linePath.move(to: CGPoint(x: 0, y: 0))
                linePath.addLine(to: CGPoint(x: 0, y: size.height))
                
                context.stroke(linePath, with: .color(.background), lineWidth: 10)
                
                let textToDraw:Text = Text("\(String(year))").font(.title)
                
                context.draw(textToDraw, at: CGPoint(x: size.width - CGFloat(marginXYear), y: 0), anchor: .topTrailing)
                

                
                var currentYPosition:Int = marginToTopForTheFirstMemmory
                
                for i in 0..<memories.count {
                    
                    let currentMemory = memories[i]
                    currentYPosition += calculateMarginTopToPreviousMemory(forMemoryAt: i)
                    
                    var p = Path()
                    
                    p.move(to: CGPoint(x: 100, y: 100))

                    let rect = CGRect(x: 0, y: currentYPosition+9, width: 10, height: 10)
                    p.addRect(rect)
                    
                    context.stroke(p, with: .color(colorScheme == .dark ? .lightBackground : .background), lineWidth: 10)
                    
                    let textToDraw = Text("\(currentMemory.name)")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    //context.draw(textToDraw, at: CGPoint(x: marginXMemory, y: currentYPosition), anchor: .topLeading)
                    
                   // GeometryReader { geo in
                    context.draw(textToDraw, in: CGRect(x: marginXMemory, y: currentYPosition, width: Int(size.width-50), height: 30))
                    //}

                    
                    currentYPosition += marginYBetweenTitleAndYear

                    let dateToDraw =
                        Text("\(currentMemory.date.formatted(date: .long, time: .omitted))")
                            .font(.title3)
                            .foregroundColor(colorScheme == .dark ? .lightBackground : .background)
                    
                    context.draw(dateToDraw, at: CGPoint(x: marginXMemory, y: currentYPosition), anchor: .topLeading)
                    
                    
                    currentYPosition += minimalMarginYBetweenTwoMemories //do some specing so that events on the same day do not overlap
                    
                }
                
                
            }
            .frame(height: requiredHeight())
            .dynamicTypeSize(...DynamicTypeSize.xxLarge)
            //.border(Color.purple)
    }
    
    func requiredHeight() -> CGFloat {
        var totalHeight = 0
        totalHeight += marginToTopForTheFirstMemmory
        
        for i in 0..<memories.count {
            totalHeight += calculateMarginTopToPreviousMemory(forMemoryAt: i)
        }
        
        if (memories.count >= 1) {
            totalHeight += calculateMarginBottomToNextMemory(forMemoryAt: memories.count-1)
        }
        
        totalHeight += (minimalMarginYBetweenTwoMemories+marginYBetweenTitleAndYear)*memories.count
        
        return CGFloat(totalHeight)
    }
    
    func calculateMarginTopToPreviousMemory(forMemoryAt index: Int) -> Int {
        let currentMemory = memories[index]
        let comparisonDate = index == 0 ? Date.lastDayOfYear(year: year) : memories[index-1].date
        let daysBetweenMemoryAndLastMemory = currentMemory.date.timeIntervalInDays(to: comparisonDate)
        let marginToPreviousMemory = Double(daysBetweenMemoryAndLastMemory)*marginFactor
        return Int(ceil(marginToPreviousMemory))
    }
    
    func calculateMarginBottomToNextMemory(forMemoryAt index: Int) -> Int {
        let currentMemory = memories[index]
        let comparisonDate = index == memories.count-1 ? Date.firstDayOfYear(year: year) : memories[index+1].date
        let daysBetweenMemoryAndNextMemory = currentMemory.date.timeIntervalInDays(to: comparisonDate)
        let marginToNextMemory = Double(daysBetweenMemoryAndNextMemory)*marginFactor
        return Int(ceil(marginToNextMemory))
    }
    
    
    
}

struct TimelineYearView_Previews: PreviewProvider {
    
    static var previews: some View {
        let  memories = Memories()
        let year = 2022
        //memories.removeAllMemories()
        return TimelineYearView(memories: memories.memoriesForYear(year), year: year, marginFactor: .constant(1.0))
            .environmentObject(memories)
    }
}
