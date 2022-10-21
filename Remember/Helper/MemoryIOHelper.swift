//
//  MemoriesSaverHelper.swift
//  Remember
//
//  Created by Jan Huber on 18.10.22.
//

import Foundation
import SwiftUI

struct MemoryIOHelper {
    
    func save(memories: [Memory]) {
                
        do {
            let data = try JSONEncoder().encode(memories)
            try data.write(to: getSavePath(), options:[.atomic, .completeFileProtection])
        } catch let error {
            print("Unable to save data. " + error.localizedDescription)
        }
        
    }
    
    private func getSavePath() -> URL {
        MemoryIOHelper.getDocumentsDirectory().appendingPathComponent("memories.json")
    }
    
    func loadMemoriesFromDisk() throws -> [Memory]  {
        return try Bundle.main.decode(getSavePath())
    }
    
    static func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
    
    static func loadImageFromDocumentDirectory(memory: Memory) -> UIImage? {
            let documentsUrl = getDocumentsDirectory()
            let fileURL = documentsUrl.appendingPathComponent(memory.id.uuidString)
            do {
                let imageData = try Data(contentsOf: fileURL)
                return UIImage(data: imageData)
            } catch {
                print("Cannot load image: " + fileURL.path)
                print(error.localizedDescription)
                return nil
            }
            
        }
    
    func getMemoryImageFileUrl(memory: Memory) -> URL {
        let documentsUrl = MemoryIOHelper.getDocumentsDirectory()
        return documentsUrl.appendingPathComponent(memory.id.uuidString)
    }
    
    func saveImageInDocumentDirectory(memory: Memory) {
        let fileURL = getMemoryImageFileUrl(memory: memory)
        if let imageData = memory.image?.pngData() {
            try? imageData.write(to: fileURL, options: .atomic)
        }
    }
    
    
    func deleteImageInDocumentDirectory(memory: Memory) {
        let fileURL = getMemoryImageFileUrl(memory: memory)
        try? FileManager.default.removeItem(at: fileURL)
    }
    
}
