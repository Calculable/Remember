//
//  UpcomingMemoryListEntryView.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import SwiftUI

struct UpcomingMemoryListEntryView: View {

    @StateObject private var viewModel = ViewModel()

    @State var anniversary: Anniversary
    @State private var showImageSavedNotification = false
    @State private var showImageSaveErrorNotification = false

    
    @State private var uiImage: UIImage? = nil
    @State var isScreenshot: Bool
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    
    var body: some View {
        
            
        
        ZStack {
            
            
            if let image = anniversary.memory.image {
                GeometryReader { geo in
        
                    Image(uiImage: image).resizable().scaledToFill().frame(width: geo.size.width).frame(height: geo.size.width).clipped()
                        .accessibilityHidden(true)
                    

                }
                
            }
            
            let increasedContrast = colorSchemeContrast == .increased

            let backgroundOpacity = reduceTransparency ? 1 : (increasedContrast ? 0.8 : 0.5)
            
            
            
            Rectangle()
                .fill(Color.black.opacity(backgroundOpacity))
                .accessibilityHidden(true)
            
            VStack(alignment: .center) {
                
                Group {
                    
                
                    Text("\(Image(systemName: "calendar.circle")) \(anniversary.date.formatted(date: .long, time: .omitted))  \n(\(describeRemainingDays(anniversary.date)))")
                        .foregroundColor(remainingDaysTo(to: anniversary.date) <= 7 ? .white : .white)
                        .multilineTextAlignment(.center)
                        .accessibilityHidden(true)
                                            
                    Text("\(getTimeIntervallDescription(anniversary: anniversary)): \(anniversary.memory.name)")
                        .font(.title)
                        .foregroundColor(.white)
                    
                }.accessibilityElement(children: .combine)
                
                if (!isScreenshot) {
                    Button("Share") {
                        shareMemoryImage()

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

    private func shareMemoryImage() {
        let view = UpcomingMemoryListEntryView(anniversary: anniversary, isScreenshot: true)
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
    }


    func getTimeIntervallDescription(anniversary: Anniversary) -> String {
        switch(anniversary.type) {
            case .year:
            return String(format: NSLocalizedString("%d years since", comment: "number of days since the anniversary"), anniversary.years)

            case .day:
                return String(format: NSLocalizedString("%d days since", comment: "number of days since the anniversary"), anniversary.days)


        }
    }
    
    func remainingDaysTo(to date: Date) -> Int {
        Calendar.current.today().timeIntervalInDays(to: date)
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
        
        var dateOfTheAnniversary = exampleMemory.date
        dateOfTheAnniversary.changeYear(to: Date.currentYear() + 1)
        
        let anniversary = Anniversary(memory: exampleMemory, date: dateOfTheAnniversary, type: .year)
        return UpcomingMemoryListEntryView(anniversary: anniversary, isScreenshot: false)
    }

}

