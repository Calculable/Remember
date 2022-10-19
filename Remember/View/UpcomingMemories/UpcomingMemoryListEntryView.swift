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
    @State private var showImageSaveErrorNotification = false

    
    @State private var uiImage: UIImage? = nil
    @State var isScreenshot: Bool
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    
    var body: some View {
        
            
        
        ZStack {
            
            
            if let image = specialDay.memory.image {
                GeometryReader { geo in
        
                    Image(uiImage: image).resizable().scaledToFill().frame(width: geo.size.width).frame(height: geo.size.width).clipped()
                        .accessibilityHidden(true)
                    

                }
                
            } //todo: display image should not be in model
            
            let increasedContrast = colorSchemeContrast == .increased

            let backgroundOpacity = reduceTransparency ? 1 : (increasedContrast ? 0.8 : 0.5)
            
            
            
            Rectangle()
                .fill(Color.black.opacity(backgroundOpacity))
                .accessibilityHidden(true)
            
            VStack(alignment: .center) {
                
                Group {
                    
                
                    Text("\(Image(systemName: "calendar.circle")) \(specialDay.dateOfTheSpecialDay.formatted(date: .long, time: .omitted))  \n(\(describeRemainingDays(specialDay.dateOfTheSpecialDay)))")
                        .foregroundColor(remainingDaysTo(to: specialDay.dateOfTheSpecialDay) <= 7 ? .white : .white)
                        .multilineTextAlignment(.center)
                        .accessibilityHidden(true)
                                            
                    Text("\(getTimeIntervallDescription(specialDay: specialDay)): \(specialDay.memory.name)")
                        .font(.title)
                        .foregroundColor(.white)
                    
                }.accessibilityElement(children: .combine)
                
                if (!isScreenshot) {
                    Button("Share") {
                        let view = UpcomingMemoryListEntryView(specialDay: specialDay, isScreenshot: true)
                        view.isScreenshot = true
                        
                        let image = view.snapshot(width: 500, height: 500)
                                 
                        let imageSaver = ImageSaver()
                        imageSaver.errorHandler = { _ in
                            showImageSaveErrorNotification = true
                        }
                        
                        imageSaver.successHandler = {
                            showImageSavedNotification = true
                        }
                        
                        
                        imageSaver.writeToPhotoAlbum(image: image)
                         
                    }.buttonStyle(.borderedProminent).tint(.background)
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
            .alert("Image could not be saved", isPresented: $showImageSaveErrorNotification) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("There was an error while saving the image")
            }
        
        
            .ignoresSafeArea()
    }
    

    func getTimeIntervallDescription(specialDay: UpcomingSpecialDay) -> String {
        switch(specialDay.type) {
            case .year:
            return String(format: NSLocalizedString("%d years since", comment: "number of days since the anniversary"), specialDay.years)

            case .day:
                return String(format: NSLocalizedString("%d days since", comment: "number of days since the anniversary"), specialDay.days)


        }
    }
    
    func remainingDaysTo(to date: Date) -> Int {
        return Calendar.current.today().timeIntervalInDays(to: date)
    }
    
    func describeRemainingDays(_ date: Date) -> String {
        let numberOfRemainingDays = remainingDaysTo(to: date)
        
        switch (numberOfRemainingDays) {
        case 0:
            return String(localized: "Today")
        case 1:
            return String(localized: "Tomorrow")
        default:
            return String(format: NSLocalizedString("In %d days", comment: "number of days remaining days"), numberOfRemainingDays)

        }
    }
    

}

class UpcomingMemoryListEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleMemory = Memory(name: "Example Memory")
        
        var dateOfSpecialDay = exampleMemory.date
        dateOfSpecialDay.changeYear(to: Date.currentYear() + 1)
        
        let specialDay = UpcomingSpecialDay(memory: exampleMemory, dateOfTheSpecialDay: dateOfSpecialDay, type: .year)
        return UpcomingMemoryListEntryView(specialDay: specialDay, isScreenshot: false)
    }

}

