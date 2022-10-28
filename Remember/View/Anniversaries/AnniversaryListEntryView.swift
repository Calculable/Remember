import SwiftUI


/// Represents the view for a single list-entry in the AnniversariesView. Contains information about the upcoming anniversary of a memory.
struct AnniversaryListEntryView: View {
    
    @Environment(\.colorSchemeContrast) private var colorSchemeContrast
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @StateObject private var viewModel: ViewModel
    
    init(anniversary: Anniversary, isScreenshot: Bool = false) {
        _viewModel = StateObject<ViewModel>(wrappedValue: ViewModel(anniversary: anniversary, isScreenshot: isScreenshot))
    }
    
    private var increasedContrast: Bool {
        colorSchemeContrast == .increased
    }
    
    private var backgroundOpacity: Double {
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
                }
                .accessibilityElement(children: .combine)
                
                if (!viewModel.isScreenshot) { //if the user saves a picture from this view, the share-button itself should not be on the image
                    Button("Share") {
                        viewModel.shareMemoryImage()
                    }
                    .buttonStyle(.borderedProminent).tint(.background)
                }
            }
        }
        .padding(viewModel.isScreenshot ? 0 : 8) //if the user saves a picture from this view, there should not be any "border" around the image
        .aspectRatio(1, contentMode: .fill) //the list entries should always be displayed in a square-shape
        .alert("Image saved", isPresented: $viewModel.showImageSavedNotification) {
            Button("OK", role: .cancel) {
            }
        } message: {
            Text("The image was saved to your photo gallery")
        }
        .alert("Image could not be saved", isPresented: $viewModel.showImageSaveErrorNotification) {
            Button("OK", role: .cancel) {
            }
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
        return AnniversaryListEntryView(anniversary: anniversary, isScreenshot: false)
    }
    
}

