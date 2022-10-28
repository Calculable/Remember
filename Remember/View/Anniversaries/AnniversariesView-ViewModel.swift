import Foundation

extension AnniversariesView {
    
    /// the view model for the AnniversariesView
    @MainActor class ViewModel: ObservableObject {
        
        @Published var searchText = ""
        
        ///contains "special" numbers used to calculate anniversaries (eventhough the name "anniversary" does not really make sense in this case). For example a day is seen as "anniversary", if a memory happened exactly 100, 500, 1000, ... days ago
        private let specialDayIntervals = [100, 500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 15000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000, 100000, 200000, 300000, 400000, 500000, 600000, 700000, 800000, 900000, 1000000]
        
        private let calendar = Calendar.current;
        
        ///generates a list of anniversaries for a given memory. The generated anniversaries are limited: Only anniversaries that will happen in the next 365 days (from the current day on) are returned
        func generateAnniversaries(memories: Memories) -> [Anniversary] {
            var result: [Anniversary] = []
            for memory in memories.availableMemories {
                result.append(nextAnniversary(of: memory));
                result.append(contentsOf: nextSpecialDayIntervals(of: memory))
            }
            return result.sorted()
        }
        
        ///returns upcoming anniversary if the memory match a given search-string
        func filteredAnniversaries(memories: Memories) -> [Anniversary] {
            let anniversaries = generateAnniversaries(memories: memories)
            
            if searchText.isEmpty {
                return anniversaries
            } else {
                return anniversaries.filter {
                    $0.memory.name.localizedCaseInsensitiveContains(searchText)
                }
            }
        }
        
        private func nextAnniversary(of memory: Memory) -> Anniversary {
            var nextAnniversary = memory.date
            nextAnniversary.changeYear(to: Date.currentYear())
            
            if (nextAnniversary < calendar.today() || (nextAnniversary == calendar.today() && memory.date.year() == Date.currentYear())) {
                nextAnniversary.changeYear(to: Date.currentYear() + 1)
            }
            
            return Anniversary(memory: memory, date: nextAnniversary, type: .year)
        }
        
        private func nextSpecialDayIntervals(of memory: Memory) -> [Anniversary] {
            var anniversaries: [Anniversary] = []
            
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
