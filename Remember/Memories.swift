//
//  Model.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import Foundation

class Memories: ObservableObject {
    
    @Published private(set) var memories: [Memory] = []
    
    func loadExampleMemories() {
        memories.append(Memory(name: "Geburt"))
        memories.append(Memory(name: "Schulabschluss Primarschule"))
        memories.append(Memory(name: "Schulabschluss Sek"))
        memories.append(Memory(name: "Schulabschluss IMS"))
        memories.append(Memory(name: "App programmiert"))
    }
    
    func addMemory(_ newMemory: Memory) {
        memories.append(newMemory)
    }
    
}
