//
//  TimelineYearView.swift
//  Remember
//
//  Created by Jan Huber on 18.08.22.
//

import Foundation

import SwiftUI

struct TimelineYearView: View {
    
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
                
                context.stroke(linePath, with: .color(.purple), lineWidth: 20)
                
                let textToDraw:Text = Text("\(String(year))").font(.title)
                
                context.draw(textToDraw, at: CGPoint(x: size.width - CGFloat(marginXYear), y: 0), anchor: .topTrailing)
                
                
                var currentYPosition:Int = marginToTopForTheFirstMemmory
                
                for i in 0..<memories.count {
                    
                    let currentMemory = memories[i]
                    currentYPosition += calculateMarginTopToPreviousMemory(forMemoryAt: i)
                    
                    context.draw(Text("\(currentMemory.name)")
                        .font(.title2)
                        .fontWeight(.bold), at: CGPoint(x: marginXMemory, y: currentYPosition), anchor: .topLeading)
                    
                    currentYPosition += marginYBetweenTitleAndYear

                    context.draw(Text("\(currentMemory.date.formatted(date: .long, time: .omitted))")
                        .font(.title2)
                        .foregroundColor(Color.gray), at: CGPoint(x: marginXMemory, y: currentYPosition), anchor: .topLeading)
                    
                    
                    currentYPosition += minimalMarginYBetweenTwoMemories //do some specing so that events on the same day do not overlap
                    
                }
                
                
            }
            .frame(height: requiredHeight())
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
        let comparisonDate = index == 0 ? Calendar.current.lastDayOfYear(year: year) : memories[index-1].date
        let daysBetweenMemoryAndLastMemory = Calendar.current.numberOfDaysBetween(currentMemory.date, and: comparisonDate)
        let marginToPreviousMemory = Double(daysBetweenMemoryAndLastMemory)*marginFactor
        return Int(ceil(marginToPreviousMemory))
    }
    
    func calculateMarginBottomToNextMemory(forMemoryAt index: Int) -> Int {
        let currentMemory = memories[index]
        let comparisonDate = index == memories.count-1 ? Calendar.current.firstDayOfYear(year: year) : memories[index+1].date
        let daysBetweenMemoryAndNextMemory = Calendar.current.numberOfDaysBetween(currentMemory.date, and: comparisonDate)
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