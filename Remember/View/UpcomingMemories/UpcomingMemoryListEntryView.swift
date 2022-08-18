//
//  UpcomingMemoryListEntryView.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import SwiftUI

struct UpcomingMemoryListEntryView: View {
    
    @State var specialDay: UpcomingSpecialDay
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(Calendar.current.describeReminingDays(specialDay.dateOfTheSpecialDay))
                .foregroundColor(Color.red)
        
            switch(specialDay.type) {
            case .year:
                Text("\(specialDay.years) Jahre seit: \(specialDay.memory.name)")
            case .day:
                Text("\(specialDay.days) Tage seit: \(specialDay.memory.name)")
            }
            
            Text("Am: \(specialDay.dateOfTheSpecialDay.formatted(date: .long, time: .omitted))")
                .foregroundColor(.secondary)
        }.frame(minHeight: 100)
    }
    

}

struct UpcomingMemoryListEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleMemory = Memory(name: "Example Memory")
        let specialDay = UpcomingSpecialDay(memory: exampleMemory, dateOfTheSpecialDay: Calendar.current.changeYearOf(date: exampleMemory.date, to: 1), type: .year)
        UpcomingMemoryListEntryView(specialDay: specialDay)
    }
}

