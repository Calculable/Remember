//
//  Model.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import Foundation

class Memories: ObservableObject {
    
    @Published private(set) var memories: [Memory] = []

    
    init() {
        do {
            memories = try Bundle.main.decode(getSavePath())
        } catch {
            print("Existing memories not found. App probably oppened for the first time")
            print(error.localizedDescription)
            print("Add example memories")
            addExampleMemories()
        }
        
    }
    
    func getSavePath() -> URL {
        getDocumentsDirectory().appendingPathComponent("memories.json")
    }
    
    func addExampleMemories() {
        memories.append(Memory(name: "Geburt"))
        memories.append(Memory(name: "Schulabschluss Primarschule"))
        memories.append(Memory(name: "Schulabschluss Sek"))
        memories.append(Memory(name: "Schulabschluss IMS"))
        memories.append(Memory(name: "App programmiert"))
        save()
    }
    
    func addMemory(_ newMemory: Memory) {
        memories.append(newMemory)
        memories.sort()
        memories.reverse()
        save()
    }
    
    func remove(_ memory: Memory) {
        memories.remove(at: memories.firstIndex(of: memory)!)
        save()
    }
    
    
    func toggleNotifications(for memory: Memory) {
        objectWillChange.send()
        memory.notificationsEnabled.toggle()
        save()
    }
    

    
    private func save() {
        do {
            let data = try JSONEncoder().encode(memories)
            try data.write(to: getSavePath(), options:[.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        // find all possible documents directories for this user
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

        // just send back the first one, which ought to be the only one
        return paths[0]
    }
    
}
