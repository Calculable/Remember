//
//  TimelineView.swift
//  Remember
//
//  Created by Jan Huber on 18.08.22.
//

import Foundation
import SwiftUI

struct TimelineView: View {
    
    @EnvironmentObject var memories: Memories

    var body: some View {
        
        /*let events = ["event1", "event2", "event3"]
        
        let heightPerEvent =
        let totalHeight = events.count * 30;
        let titleOffset*/
        
        
        NavigationView {
            ScrollView {
                
                VStack(spacing: 0.0) {
                    
                    let minYear = memories.oldestYear()
                    let maxYear = memories.newestYear()
                    
                   
                    
                    if let minYear = minYear, let maxYear = maxYear {
                        let amountOfYears = (maxYear-minYear)+1
                        
                        ForEach(0..<amountOfYears, id: \.self) { decrementYear in //workaround to loop in reverse order
                            let currentYear = maxYear - decrementYear
                            TimelineYearView(memories: memories.memoriesForYear(currentYear), year: currentYear)
                        }
                    } else {
                        Text("No Memories to display")

                    }
                    
                }
                
            }.navigationBarTitle("Timeline")
                
                
        }
        
    }
}
