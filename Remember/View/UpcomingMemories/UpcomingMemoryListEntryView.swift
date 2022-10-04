//
//  UpcomingMemoryListEntryView.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import SwiftUI

struct UpcomingMemoryListEntryView: View {
    
    @State var specialDay: UpcomingSpecialDay
    @State private var showImageSavedNotification = false
    @State private var uiImage: UIImage? = nil
    @State var isScreenshot: Bool

    
    var body: some View {
        
            
        
        ZStack {
            
            
            if let image = specialDay.memory.image {
                GeometryReader { geo in
        
                    Image(uiImage: image).resizable().scaledToFill().frame(width: geo.size.width).frame(height: geo.size.width).clipped()
                    

                }
                
            } //todo: display image should not be in model
            
            Rectangle()
                   .fill(Color.black.opacity(0.5))
            
            VStack(alignment: .center) {
                Text("\(Image(systemName: "calendar.circle")) \(specialDay.dateOfTheSpecialDay.formatted(date: .long, time: .omitted))  \n(\(describeRemainingDays(specialDay.dateOfTheSpecialDay)))")
                    .foregroundColor(remainingDaysTo(to: specialDay.dateOfTheSpecialDay) <= 7 ? .red : .white)
                    .multilineTextAlignment(.center)
                                        
                                         
                switch(specialDay.type) {
                case .year:
                    Text("\(specialDay.years) years since: \(specialDay.memory.name)")
                        .font(.title)
                        .foregroundColor(.white)
                case .day:
                    Text("\(specialDay.days) days since: \(specialDay.memory.name)")
                        .font(.title)
                        .foregroundColor(.white)

                }
                
                if (!isScreenshot) {
                    Button("Share") {
                        print("save to photo gallery")
                        let view = UpcomingMemoryListEntryView(specialDay: specialDay, isScreenshot: true)
                        view.isScreenshot = true
                        UIImageWriteToSavedPhotosAlbum(view.snapshot(width: 500, height: 500), nil, nil, nil)
                        showImageSavedNotification = true
 
                    }.buttonStyle(.borderedProminent)
                }


            }

                
        }
        
        .padding(isScreenshot ? 0 : 8)
            .aspectRatio(1, contentMode: .fill)

            .alert("Image saved", isPresented: $showImageSavedNotification) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The image was saved to your photo gallery")
            }
            .ignoresSafeArea()
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
        return UpcomingMemoryListEntryView(specialDay: specialDay, isScreenshot: false)
    }
}

