import Foundation
import SwiftUI


/// Contains helper functions to load memory-related data from the disk or write memory-related data to the disk
class MemoryIOHelper {
    
    /// Stores a list of memory on the local disk. Previously existing data is overwritten.
    func saveMemories(_ memories: [Memory]) {
        
        do {
            let data = try JSONEncoder().encode(memories)
            try data.write(to: getSavePath(), options: [.atomic, .completeFileProtection])
        } catch let error {
            print("Unable to save data. " + error.localizedDescription)
        }
    }
    
    /// Loads previously stored memories from the disk again
    func loadMemoriesFromDisk() throws -> [Memory] {
        return try Bundle.main.decode(getSavePath())
    }
    
    /// Loads the image data for a memory from the disk and converts it to a displayable image
    func loadImageFromDocumentDirectory(forMemory memory: Memory) -> UIImage? {
        let fileURL = getImageFileURL(forMemory: memory)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Cannot load image: " + fileURL.path)
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Saves the image data for a memory from the disk
    func saveImageInDocumentDirectory(forMemory memory: Memory) {
        let fileURL = getImageFileURL(forMemory: memory)
        if let imageData = memory.image?.pngData() {
            try? imageData.write(to: fileURL, options: .atomic)
        }
    }
    
    /// Deletes the image data for a memory from the disk
    func deleteImageInDocumentDirectory(forMemory memory: Memory) {
        let fileURL = getImageFileURL(forMemory: memory)
        try? FileManager.default.removeItem(at: fileURL)
    }
    
    
    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    /// Returns the link to the .JSON-File that stores all memories
    func getSavePath() -> URL {
        getDocumentsDirectory().appendingPathComponent("memories.json")
    }
    
    private func getImageFileURL(forMemory memory: Memory) -> URL {
        let documentsUrl = getDocumentsDirectory()
        return documentsUrl.appendingPathComponent(memory.id.uuidString)
    }
    
}
