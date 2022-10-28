import SwiftUI
import MapKit


extension EditMemoryView {
    
    /// View model for the EditMemoryView
    @MainActor class ViewModel: ObservableObject {
        
        @Published private(set) var isCustomCoordinate = false //did the user choose a custom coordinate for this memory?
        @Published var coordinate = CLLocationCoordinate2D(latitude: 46.818188, longitude: 8.227512) //initialized with the default coordiante
        @Published var showingMapPicker = false
        
        //The following properties represent the data that the user entered and that is converted to a memory-instance once the user clicks on "save"
        @Published var name: String = ""
        @Published var date: Date = Date.now
        @Published var image: UIImage?
        @Published var notes: String = ""
        @Published var notificationsEnabled = false
        @Published var showingImagePicker = false
        @Published var existingMemory: Memory? = nil
        
        var onMemoryUpdated: ((Memory) -> Void)? //This callback is provided so that interested UI-components can get informed once a memory changes and the view should be redrawn.
        
        var displayImage: Image? {
            guard let image = image else {
                return nil
            }
            
            return Image(uiImage: image)
        }
        
        var saveDisabled: Bool {
            return name.isEmpty //entering a name is required
        }
        
        init(_ memory: Memory? = nil, onMemoryUpdated: ((Memory) -> Void)? = nil) {
            if let memory = memory {
                if let memoryCoordinate = memory.coordinate {
                    isCustomCoordinate = true
                    coordinate = memoryCoordinate
                }
                
                self.name = memory.name
                self.date = memory.date
                self.image = memory.image
                self.notes = memory.notes
                self.notificationsEnabled = memory.notificationsEnabled
                self.existingMemory = memory
            }
            
            self.onMemoryUpdated = onMemoryUpdated
            
        }
        
        func removeImage() {
            image = nil
        }
        
        func showImagePicker() {
            showingImagePicker = true
        }
        
        func showMapPicker() {
            showingMapPicker = true
        }
        
        func saveNewMemory(memories: Memories) {
            if let memory = existingMemory {
                memories.remove(memory) //memories are "updated" by deleting and re-creating them
            }
        
            let customCoordinate = isCustomCoordinate ? coordinate : nil
            let newMemory = Memory(name: name, date: date, image: image, coordinate: customCoordinate, notes: notes, notificationsEnabled: notificationsEnabled)
            memories.addMemory(newMemory)
            
            existingMemory = newMemory
            onMemoryUpdated?(newMemory)
        }
        
        func markAsCustomCoordinate() {
            isCustomCoordinate = true
        }
        
        func markAsNonCustomCoordinate() {
            isCustomCoordinate = false
        }
    }
}
