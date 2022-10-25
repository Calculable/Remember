//
//  MemoriesSaverHelper.swift
//  Remember
//
//  Created by Jan Huber on 18.10.22.
//

import Foundation
import SwiftUI

class MemoryIOHelper {

    func saveMemories(_ memories: [Memory]) {

        do {
            let data = try JSONEncoder().encode(memories)
            try data.write(to: getSavePath(), options: [.atomic, .completeFileProtection])
        } catch let error {
            print("Unable to save data. " + error.localizedDescription)
        }

    }


    func loadMemoriesFromDisk() throws -> [Memory] {
        return try Bundle.main.decode(getSavePath())
    }

    func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }


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

    func getImageFileURL(forMemory memory: Memory) -> URL {
        let documentsUrl = getDocumentsDirectory()
        return documentsUrl.appendingPathComponent(memory.id.uuidString)
    }

    func saveImageInDocumentDirectory(forMemory memory: Memory) {
        let fileURL = getImageFileURL(forMemory: memory)
        if let imageData = memory.image?.pngData() {
            try? imageData.write(to: fileURL, options: .atomic)
        }
    }


    func deleteImageInDocumentDirectory(forMemory memory: Memory) {
        let fileURL = getImageFileURL(forMemory: memory)
        try? FileManager.default.removeItem(at: fileURL)
    }

    private func getSavePath() -> URL {
        getDocumentsDirectory().appendingPathComponent("memories.json")
    }

}
