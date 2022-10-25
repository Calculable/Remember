//
//  CalendarExtension.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import Foundation

extension Calendar {


    func today() -> Date {
        let dateComponents = dateComponents([.year, .month, .day], from: Date())
        return date(from: dateComponents)!
    }


}
