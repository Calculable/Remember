//
//  MemoriesSaverHelper.swift
//  Remember
//
//  Created by Jan Huber on 18.10.22.
//

import Foundation

class MemoriesSaverHelper {
    
    func save(memories: [Memory]) {
                
        do {
            let data = try JSONEncoder().encode(memories)
            try data.write(to: getSavePath(), options:[.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
        
    }
    
    private func getSavePath() -> URL {
        getDocumentsDirectory().appendingPathComponent("memories.json")
    }
    
    func loadMemoriesFromDisk() throws -> [Memory]  {
        return try Bundle.main.decode(getSavePath())
    }
    
    private func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
}
