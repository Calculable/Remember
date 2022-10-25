//
//  DateExtensions.swift
//  Remember
//
//  Created by Jan Huber on 17.08.22.
//

import Foundation

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
    
    
    mutating func changeYear(to year: Int) {
        var dateComponents = Calendar.current.dateComponents([.month, .day], from: self)
        dateComponents.year = year
        self = Calendar.current.date(from: dateComponents)!
    }

    static func currentYear() -> Int {
        return Date().year()
    }
    
    static func firstDayOfYear(year: Int) -> Date { //january 1
        return Date(day: 1, month: 1, year: year)
    }

    static func lastDayOfYear(year: Int) -> Date { //december 31
        return Date(day: 31, month: 12, year: year)
    }
    
    func timeIntervalInDays(to: Date) -> Int {
        let toDate = Calendar.current.startOfDay(for: to) // <2>
        let numberOfDays = Calendar.current.dateComponents([.day], from:  Calendar.current.startOfDay(for: self), to: toDate) // <3>
        
        return abs(numberOfDays.day!)
    }


    func year() -> Int {
        return Calendar.current.component(.year, from: self)
    }


    func isInLessThanAYear() -> Bool {
        return isInLessThanAYear(after: Calendar.current.today())
    }

    func isInLessThanAYear(after otherDate: Date) -> Bool {
        var otherDateCopy = otherDate
        otherDateCopy.changeYear(to: Date.currentYear() + 1)
        return (self < otherDateCopy) && (self >= otherDate)
    }


}
