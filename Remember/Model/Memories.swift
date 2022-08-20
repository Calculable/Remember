//
//  Model.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import Foundation
import UIKit

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
        
        let firstDayOfYear = Date.firstDayOfYear(year: 2022)
        let lastDayOfYear = Date.lastDayOfYear(year: 2022)

        memories.append(Memory(name: "Jahresbeginn 1", date: firstDayOfYear))
        memories.append(Memory(name: "Jahresbeginn 2", date: firstDayOfYear))
        memories.append(Memory(name: "Jahresende 1", date: lastDayOfYear))
        memories.append(Memory(name: "Jahresende 2", date: lastDayOfYear))
        
        memories.append(Memory(name: "Moonlanding", date: Date(day: 16, month: 7, year: 1969), image: UIImage(named:"moon")))


        sortMemories()
        save()
    }
    
    func addMemory(_ newMemory: Memory) {
        memories.append(newMemory)
        sortMemories()
        save()
    }
    
    func sortMemories() {
        memories.sort()
        memories.reverse()
    }
    
    func removeAllMemories() {
        memories = []
        addExampleMemories()
    }
    
    func remove(_ memory: Memory) {
        memory.image = nil //triggers deletion of the image

        memories.remove(at: memories.firstIndex(of: memory)!)
        save()
    }
    
    
    func toggleNotifications(for memory: Memory) {
        objectWillChange.send()
        memory.notificationsEnabled.toggle()
        save()
    }
    
    func newestYear() -> Int? {
        return memories.map({memory in memory.date.year()}).max();
    }
    
    func oldestYear() -> Int? {
        return memories.map({memory in memory.date.year()}).min();
    }
    
    func memoriesForYear(_ year: Int) -> [Memory] {
        return memories.filter { memory in
            return memory.date.year() == year;
        }
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
