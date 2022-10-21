//
//  UpcomingMemoriesView-ViewModel.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import Foundation

extension UpcomingMemoriesView {
    @MainActor class ViewModel: ObservableObject {
        
        let specialDayIntervals = [100, 500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 15000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000, 100000, 200000, 300000, 400000, 500000, 600000, 700000, 800000, 900000, 1000000]
        
        let calendar = Calendar.current;

        
        func generateAnniversaries(memories: Memories) -> [Anniversary] {
            var result: [Anniversary] = []
            for memory in memories.availableMemories {
                result.append(nextAnniversary(of: memory));
                result.append(contentsOf: nextSpecialDayIntervals(of: memory))
            }
            return result.sorted()
        }
        
        func nextAnniversary(of memory: Memory) -> Anniversary {
            
            
            
            var nextAnniversary = memory.date
            nextAnniversary.changeYear(to: Date.currentYear())
            
                        
            if (nextAnniversary < calendar.today() || (nextAnniversary == calendar.today() && memory.date.year() == Date.currentYear())) {
                nextAnniversary.changeYear(to: Date.currentYear()+1)
            }
            
            return Anniversary(memory: memory, date: nextAnniversary, type: .year)
        }
        
        func nextSpecialDayIntervals(of memory: Memory) -> [Anniversary] {
            var anniversaries:[Anniversary] = []
            
            for specialDayInterval in specialDayIntervals {
                let modifiedDate = Calendar.current.date(byAdding: .day, value: specialDayInterval, to: memory.date)!
                if (modifiedDate.isInLessThanAYear()) {
                    anniversaries.append(Anniversary(memory: memory, date: modifiedDate, type: .day))
                }
            }
            return anniversaries
        }
        
    }
}
