import Foundation

/// An enniversary represents the date on which a memory occured exactely 1, 2, 3... years ago or a special number of days ago, for example 1000 days
struct Anniversary: Identifiable, Comparable {
    
    let id = UUID()
    let memory: Memory
    
    
    /// The date of the anniversary (this is not the date when the memory happened!)
    let date: Date
    
    /// There are two types of anniversaries: day or year.  An anniversary-type of "year" means, that a memory happened 1, 2, 3... years ago. An enniversary-type of "day" means that a memory happened a special number of days ago (for example 1000 days ago)
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
