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
            Text("\(Image(systemName: "calendar.circle")) \(specialDay.dateOfTheSpecialDay.formatted(date: .long, time: .omitted))  \n(\(describeRemainingDays(specialDay.dateOfTheSpecialDay)))")
                .foregroundColor(remainingDaysTo(to: specialDay.dateOfTheSpecialDay) <= 7 ? .purple : .secondary)
                                    
                            
        
            switch(specialDay.type) {
            case .year:
                Text("\(specialDay.years) years since: \(specialDay.memory.name)")
                    .font(.headline)
            case .day:
                Text("\(specialDay.days) days since: \(specialDay.memory.name)")
                    .font(.headline)
            }
            
            
            //Text("Am: \(specialDay.dateOfTheSpecialDay.formatted(date: .long, time: .omitted))")
            //    .foregroundColor(.secondary)
        }
        .frame(minHeight: 100)
            .contextMenu {
                Button("Save to photo gallery") {
                    print("save to photo gallery")
                    UIImageWriteToSavedPhotosAlbum(self.snapshot(), nil, nil, nil)

                }
            }
    }
    
    func remainingDaysTo(to date: Date) -> Int {
        return Calendar.current.today().timeIntervalInDays(to: date)
    }
    
    func describeRemainingDays(_ date: Date) -> String {
        let numberOfRemainingDays = remainingDaysTo(to: date)
        
        switch (numberOfRemainingDays) {
        case 0:
            return "Today"
        case 1:
            return "Tomorrow"
        default:
            return "In \(numberOfRemainingDays) days"
        }
    }
    

}

struct UpcomingMemoryListEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleMemory = Memory(name: "Example Memory")
        
        var dateOfSpecialDay = exampleMemory.date
        dateOfSpecialDay.changeYear(to: Date.currentYear() + 1)
        
        let specialDay = UpcomingSpecialDay(memory: exampleMemory, dateOfTheSpecialDay: dateOfSpecialDay, type: .year)
        return UpcomingMemoryListEntryView(specialDay: specialDay)
    }
}

