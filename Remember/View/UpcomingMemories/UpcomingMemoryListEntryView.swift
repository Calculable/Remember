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
        .frame(minHeight: 100)
            .contextMenu {
                Button("Save to photo gallery") {
                    print("save to photo gallery")
                    UIImageWriteToSavedPhotosAlbum(self.snapshot(), nil, nil, nil)

                }
            }
    }
    
    func describeReminingDays(_ date: Date) -> String {
        let numberOfReminingDays = Calendar.current.today().timeIntervalInDays(to: date)
        
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

struct UpcomingMemoryListEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleMemory = Memory(name: "Example Memory")
        
        var dateOfSpecialDay = exampleMemory.date
        dateOfSpecialDay.changeYear(to: Date.currentYear() + 1)
        
        let specialDay = UpcomingSpecialDay(memory: exampleMemory, dateOfTheSpecialDay: dateOfSpecialDay, type: .year)
        return UpcomingMemoryListEntryView(specialDay: specialDay)
    }
}

