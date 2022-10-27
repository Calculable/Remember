import Foundation

struct Anniversary: Identifiable, Comparable {
    
    let id = UUID()
    let memory: Memory
    let date: Date
    let type: AnniversaryType
    
    static func <(lhs: Anniversary, rhs: Anniversary) -> Bool {
        lhs.date < rhs.date
    }
    
    var days: Int {
        return memory.date.timeIntervalInDays(to: date)
    }
    
    var years: Int {
        let year1 = Calendar.current.dateComponents([.year], from: date).year!
        let year2 = Calendar.current.dateComponents([.year], from: memory.date).year!
        return year1 - year2
    }
}
