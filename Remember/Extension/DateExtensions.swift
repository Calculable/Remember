import Foundation

///Date is made conform to RawRepresentable to be able to encode a date in a JSON string and decode a date from a JSON string
extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()
    
    public var rawValue: String {
        Date.formatter.string(from: self)
    }
    
    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

extension Date {
    
    public init(day: Int, month: Int, year: Int) {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        components.hour = 0
        components.minute = 0
        components.second = 0
        self = Calendar.current.date(from: components)!
    }
    
    
    /// Changes the year of the date
    /// - Parameter year: the new year of the date
    mutating func changeYear(to year: Int) {
        var dateComponents = Calendar.current.dateComponents([.month, .day], from: self)
        dateComponents.year = year
        self = Calendar.current.date(from: dateComponents)!
    }
    
    /// Returns the current year (of today's date)
    static func currentYear() -> Int {
        return Date().year()
    }
    
    /// Returns the first of january for a given year
    static func firstDayOfYear(year: Int) -> Date { //january 1
        return Date(day: 1, month: 1, year: year)
    }
    
    /// Returns the 31th december for a given year
    static func lastDayOfYear(year: Int) -> Date { //december 31
        return Date(day: 31, month: 12, year: year)
    }
    
    /// Counts the days between the current date and another date instancee
    func timeIntervalInDays(to: Date) -> Int {
        let toDate = Calendar.current.startOfDay(for: to) // <2>
        let numberOfDays = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: self), to: toDate) // <3>
        
        return abs(numberOfDays.day!)
    }
    
    /// Extracts the year of a date
    func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }
    
    /// Decides wether the date will occure in less than a year (based on today's date)
    func isInLessThanAYear() -> Bool {
        return isInLessThanAYear(after: Calendar.current.today())
    }
    
    /// Decides wether the date is in less then a year (based on another date)
    func isInLessThanAYear(after otherDate: Date) -> Bool {
        var otherDateCopy = otherDate
        otherDateCopy.changeYear(to: Date.currentYear() + 1)
        return (self < otherDateCopy) && (self >= otherDate)
    }
}
