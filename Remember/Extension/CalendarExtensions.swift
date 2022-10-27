import Foundation

extension Calendar {
    func today() -> Date {
        let dateComponents = dateComponents([.year, .month, .day], from: Date())
        return date(from: dateComponents)!
    }
}
