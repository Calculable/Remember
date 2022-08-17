//
//  UpcomingSpecialDay.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import Foundation

struct UpcomingSpecialDay: Identifiable, Comparable {
    
    let id = UUID()
    let memory: Memory
    let dateOfTheSpecialDay: Date
    let type: SpecialDayType
    
    static func < (lhs: UpcomingSpecialDay, rhs: UpcomingSpecialDay) -> Bool {
        lhs.dateOfTheSpecialDay < rhs.dateOfTheSpecialDay
    }
    
    var days:Int {
        return Calendar.current.numberOfDaysBetween(memory.date, and: dateOfTheSpecialDay)
    }
    
    var years:Int {
        let year1 = Calendar.current.dateComponents([.year], from: dateOfTheSpecialDay).year!
        let year2 = Calendar.current.dateComponents([.year], from: memory.date).year!
        return year1 - year2
        
    }
    
    enum SpecialDayType {
        case day, year
    }
    
}
