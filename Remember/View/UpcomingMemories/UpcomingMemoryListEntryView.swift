//
//  UpcomingMemoryListEntryView.swift
//  Remember
//
//  Created by Jan Huber on 16.08.22.
//

import SwiftUI

struct UpcomingMemoryListEntryView: View {


    @StateObject private var viewModel: ViewModel
    
    init(anniversary: Anniversary, isScreenshot: Bool = false) {
        _viewModel = StateObject<ViewModel>(wrappedValue: ViewModel(anniversary: anniversary, isScreenshot: isScreenshot))
    }

    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    var increasedContrast: Bool {
        colorSchemeContrast == .increased
    }

    var backgroundOpacity: Double {
        reduceTransparency ? 1 : (increasedContrast ? 0.8 : 0.5)
    }



    var body: some View {
        
            
        
        ZStack {
            
            
            if let image = viewModel.anniversary.memory.image {
                GeometryReader { geo in
        
                    Image(uiImage: image).resizable().scaledToFill().frame(width: geo.size.width).frame(height: geo.size.width).clipped()
                        .accessibilityHidden(true)
                    

                }
                
            }

            Rectangle()
                .fill(Color.black.opacity(backgroundOpacity))
                .accessibilityHidden(true)
            
            VStack(alignment: .center) {
                
                Group {
                    
                
                    Text("\(Image(systemName: "calendar.circle")) \(viewModel.anniversary.date.formatted(date: .long, time: .omitted))  \n(\(viewModel.describeRemainingDays(until: viewModel.anniversary.date)))")
                        .foregroundColor(viewModel.remainingDays(to: viewModel.anniversary.date) <= 7 ? .white : .white)
                        .multilineTextAlignment(.center)
                        .accessibilityHidden(true)
                                            
                    Text("\(viewModel.timeIntervalDescription(anniversary: viewModel.anniversary)): \(viewModel.anniversary.memory.name)")
                        .font(.title)
                        .foregroundColor(.white)
                    
                }.accessibilityElement(children: .combine)
                
                if (!viewModel.isScreenshot) {
                    Button("Share") {
                        viewModel.shareMemoryImage()

                    }.buttonStyle(.borderedProminent).tint(.background)
                }


            }

                
        }
        
        .padding(viewModel.isScreenshot ? 0 : 8)
            .aspectRatio(1, contentMode: .fill)

            .alert("Image saved", isPresented: $viewModel.showImageSavedNotification) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("The image was saved to your photo gallery")
            }
            .alert("Image could not be saved", isPresented: $viewModel.showImageSaveErrorNotification) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("There was an error while saving the image")
            }
        
        
            .ignoresSafeArea()
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

