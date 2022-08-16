//
//  UpcomingMemoriesView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI
import Foundation

struct UpcomingMemoriesView: View {
    
    let specialDayIntervals = [100, 500, 1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 15000, 20000, 30000, 40000, 50000, 60000, 70000, 80000, 90000, 100000, 200000, 300000, 400000, 500000, 600000, 700000, 800000, 900000, 1000000]
    
    
    @EnvironmentObject var memories: Memories

    var upcomingSpecialDays: [UpcomingSpecialDay] {
        var result: [UpcomingSpecialDay] = []
        for memory in memories.memories {
            result.append(nextAnniversary(of: memory));
            result.append(contentsOf: nextSpecialDays(of: memory))
        }
        return result.sorted()
    }
    
    func nextAnniversary(of memory: Memory) -> UpcomingSpecialDay {
        
        
        var nextAnniversary =  changeYearOf(date: memory.date, to: currentYear())
        
        if (nextAnniversary < today() || (nextAnniversary == today() && yearOf(date: memory.date) == currentYear())) {
            nextAnniversary = changeYearOf(date: memory.date, to: currentYear() + 1)
        }
        
        return UpcomingSpecialDay(memory: memory, dateOfTheSpecialDay: nextAnniversary, type: .year)
                
    }
    
    func yearOf(date: Date) -> Int {
        return Calendar.current.component(.year, from: date)
    }
    
    func currentYear() -> Int {
        return yearOf(date: Date())
    }
    
    func changeYearOf(date: Date, to year: Int) -> Date {
        var dateComponents = Calendar.current.dateComponents([.month, .day], from: date)
        dateComponents.year = year
        let newDate = Calendar.current.date(from: dateComponents)!
        return newDate
    }
    
    func today() -> Date {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        return Calendar.current.date(from: dateComponents)!
    }
    
    func isInLessThanAYear(_ date: Date) -> Bool {
        let todayInAYear = changeYearOf(date: today(), to: currentYear() + 1)
        return (date < todayInAYear) && (date >= today())
        
    }
    
    
    func nextSpecialDays(of memory: Memory) -> [UpcomingSpecialDay] {
        
        var specialDays:[UpcomingSpecialDay] = []
        
        for specialDayInterval in specialDayIntervals {
            let modifiedDate = Calendar.current.date(byAdding: .day, value: specialDayInterval, to: memory.date)!
            if (isInLessThanAYear(modifiedDate)) {
                specialDays.append(UpcomingSpecialDay(memory: memory, dateOfTheSpecialDay: modifiedDate, type: .day))
            }
        }
        
        return specialDays
    }
    
    func describeReminingDays(_ date: Date) -> String {
        let numberOfReminingDays = Calendar.current.numberOfDaysBetween(today(), and: date)
        
        switch (numberOfReminingDays) {
        case 0:
            return "Today"
        case 1:
            return "Tomorrow"
        default:
            return "In \(numberOfReminingDays) days"
        }
    }
    
    var body: some View {
        
        NavigationView {
            
                
                
                List {
                    ForEach(upcomingSpecialDays) { specialDay in
                        VStack(alignment: .leading) {
                            Text(describeReminingDays(specialDay.dateOfTheSpecialDay))
                                .foregroundColor(Color.red)
                            
                            
                            switch(specialDay.type) {
                            case .year:
                                Text("\(specialDay.years) Jahre seit: \(specialDay.memory.name)")
                            case .day:
                                Text("\(specialDay.days) Tage seit: \(specialDay.memory.name)")
                            }
                            
                            
                            Text("Am: \(specialDay.dateOfTheSpecialDay.formatted(date: .long, time: .omitted))")
                                .foregroundColor(.secondary)
                        }
                        
                    }
                        
                    
                }
                .navigationTitle("Special Days")
                
            
        }
        
    }
}

struct UpcomingMemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let memories = Memories()
        return UpcomingMemoriesView()
            .environmentObject(memories)
    }
}

