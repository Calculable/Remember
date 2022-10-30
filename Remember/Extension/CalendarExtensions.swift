import Foundation

extension Calendar {
    
    
    /// Returns todays  date (only day, month and year)
    func today() -> Date {
        let dateComponents = dateComponents([.year, .month, .day], from: Date())
        return date(from: dateComponents)!
    }
}
