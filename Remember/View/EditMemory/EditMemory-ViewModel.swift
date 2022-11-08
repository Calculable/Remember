import SwiftUI
import MapKit


extension EditMemoryView {
    
    /// View model for the EditMemoryView
    @MainActor class ViewModel: ObservableObject {
        
        @Published private(set) var isCustomCoordinate = false //did the user choose a custom coordinate for this memory?
        @Published var coordinate = CLLocationCoordinate2D(latitude: 37.333747, longitude: -122.011448) //initialized with the default coordiante
        @Published var showingMapPicker = false
        @Published var showingImageErrorMessage = false
        
        //The following properties represent the data that the user entered and that is converted to a memory-instance once the user clicks on "save"
        @Published var name: String = ""
        @Published var date: Date = Date.now
        @Published var image: UIImage? {
            didSet {
                if oldValue != nil || existingMemory == nil {
                    imageWasChanged = true
                }
            }
        }
        @Published var notes: String = ""
        @Published var notificationsEnabled = false
        @Published var showingImagePicker = false
        @Published var existingMemory: Memory? = nil
        
        private var imageWasChanged = false //if the image was not changed, deleting and re-loading the file is avoided for performance reasons
                
        var displayImage: Image? {
            guard let image = image else {
                return nil
            }
            
            return Image(uiImage: image)
        }
        
        var saveDisabled: Bool {
            return name.isEmpty //entering a name is required
        }
        
        init(_ memory: Memory? = nil) {
            if let memory = memory {
                if let memoryCoordinate = memory.coordinate {
                    isCustomCoordinate = true
                    coordinate = memoryCoordinate
                }
                
                self.existingMemory = memory
                self.name = memory.name
                self.date = memory.date
                self.image = memory.image
                self.notes = memory.notes
                self.notificationsEnabled = memory.notificationsEnabled
            }
        }
        
        func removeImage() {
            image = nil //swift ui shows a runtimewarning when this line gets executed but it seems to be an Xcode-Bug: https://www.donnywals.com/xcode-14-publishing-changes-from-within-view-updates-is-not-allowed-this-will-cause-undefined-behavior/
        }
        
        func showImagePicker() {
            showingImagePicker = true //swift ui shows a runtimewarning when this line gets executed but it seems to be an Xcode-Bug: https://www.donnywals.com/xcode-14-publishing-changes-from-within-view-updates-is-not-allowed-this-will-cause-undefined-behavior/
        }
        
        func showMapPicker() {
            showingMapPicker = true
        }
        
        func saveMemory(memories: Memories) {
            let customCoordinate = isCustomCoordinate ? coordinate : nil
            
            if let existingMemory = existingMemory {
                //update existing memory
                existingMemory.name = name
                existingMemory.date = date
                existingMemory.image = image
                existingMemory.coordinate = customCoordinate
                existingMemory.notes = notes
                existingMemory.notificationsEnabled = notificationsEnabled
                memories.memoryWasUpdated(existingMemory, imageWasChanged: imageWasChanged)
            } else {
                //save as new memory
                let newMemory = Memory(name: name, date: date, image: image, coordinate: customCoordinate, notes: notes, notificationsEnabled: notificationsEnabled, saveImageToDisk: imageWasChanged)
                memories.addMemory(newMemory)
                existingMemory = newMemory
            }
        }
        
        func markAsCustomCoordinate() {
            isCustomCoordinate = true
        }
        
        func markAsNonCustomCoordinate() {
            isCustomCoordinate = false
        }
        
        func showImageCannotBeLoadedErrorMessage() {
            showingImageErrorMessage = true
        }
    }
}
