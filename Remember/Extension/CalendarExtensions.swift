//
//  CalendarExtension.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import Foundation

extension Calendar {
    
    //source: https://sarunw.com/posts/getting-number-of-days-between-two-dates/
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        
        return numberOfDays.day!
    }
    
    func yearOf(date: Date) -> Int {
        return component(.year, from: date)
    }
    
    func currentYear() -> Int {
        return yearOf(date: Date())
    }
    
    func changeYearOf(date: Date, to year: Int) -> Date {
        var dateComponents = dateComponents([.month, .day], from: date)
        dateComponents.year = year
        let newDate = self.date(from: dateComponents)!
        return newDate
    }
    
    func today() -> Date {
        let dateComponents = dateComponents([.year, .month, .day], from: Date())
        return date(from: dateComponents)!
    }
    
    func isInLessThanAYear(_ date: Date) -> Bool {
        let todayInAYear = changeYearOf(date: today(), to: currentYear() + 1)
        return (date < todayInAYear) && (date >= today())
    }
    
    func describeReminingDays(_ date: Date) -> String {
        let numberOfReminingDays = numberOfDaysBetween(today(), and: date)
        
        switch (numberOfReminingDays) {
        case 0:
            return "Today"
        case 1:
            return "Tomorrow"
        default:
            return "In \(numberOfReminingDays) days"
        }
    }
    
    

}
