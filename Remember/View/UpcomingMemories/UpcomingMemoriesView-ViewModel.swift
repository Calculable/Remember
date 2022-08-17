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

        
        func generateUpcomingSpecialDays(memories: Memories) -> [UpcomingSpecialDay] {
            var result: [UpcomingSpecialDay] = []
            for memory in memories.memories {
                result.append(nextAnniversary(of: memory));
                result.append(contentsOf: nextSpecialDayIntervals(of: memory))
            }
            return result.sorted()
        }
        
        func nextAnniversary(of memory: Memory) -> UpcomingSpecialDay {
            var nextAnniversary =  calendar.changeYearOf(date: memory.date, to: calendar.currentYear())
            
            if (nextAnniversary < calendar.today() || (nextAnniversary == calendar.today() && calendar.yearOf(date: memory.date) == calendar.currentYear())) {
                nextAnniversary = calendar.changeYearOf(date: memory.date, to: calendar.currentYear() + 1)
            }
            
            return UpcomingSpecialDay(memory: memory, dateOfTheSpecialDay: nextAnniversary, type: .year)
        }
        
        func nextSpecialDayIntervals(of memory: Memory) -> [UpcomingSpecialDay] {
            var specialDays:[UpcomingSpecialDay] = []
            
            for specialDayInterval in specialDayIntervals {
                let modifiedDate = Calendar.current.date(byAdding: .day, value: specialDayInterval, to: memory.date)!
                if (calendar.isInLessThanAYear(modifiedDate)) {
                    specialDays.append(UpcomingSpecialDay(memory: memory, dateOfTheSpecialDay: modifiedDate, type: .day))
                }
            }
            return specialDays
        }
        
    }
}
