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
    

}
