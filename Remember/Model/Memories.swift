//
//  Model.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import Foundation
import UIKit
import MapKit


class Memories: ObservableObject {
    
    @Published private(set) var memories: [Memory] = []
    let notificationHelper: NotificationHelper
    let memoryIOHelper: MemoryIOHelper

    var availableMemories: [Memory] {
        memories.filter {
            !$0.isMarkedForDeletion
        }
    }
    
    var memoriesMarkedForDeletion: [Memory] {
        memories.filter {
            $0.isMarkedForDeletion
        }
    }
    
    init(notificationHelper: NotificationHelper = NotificationHelper(), memoryIOHelper: MemoryIOHelper = MemoryIOHelper()) {
        self.notificationHelper = notificationHelper
        self.memoryIOHelper = memoryIOHelper

        do {
            memories = try memoryIOHelper.loadMemoriesFromDisk()
        } catch {
            print("Existing memories not found. App probably oppened for the first time")
            print(error.localizedDescription)
            addExampleMemories()
        }
        
    }
    
    func addExampleMemories() {
        memories.append(contentsOf: (historicExampleMemories))
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
    
    func markForDeletion(_ memory: Memory) {
        objectWillChange.send()
        
        notificationHelper.removeNotification(for: memory) //redundant because all notifications get recreated on save
        memory.isMarkedForDeletion = true
        save()
    }
    
    func restore(_ memory: Memory) {
        objectWillChange.send()
        
        memory.isMarkedForDeletion = false
        save()
    }
    
    func deleteMarkedMemories() {
        for memoryToDelete in memoriesMarkedForDeletion {
            remove(memoryToDelete)
        }
    }
    
    func remove(_ memory: Memory) {
        notificationHelper.removeNotification(for: memory) //redundant because all notifications get recreated on save

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
        
        memoryIOHelper.save(memories: memories)
        
        notificationHelper.updateNotifications(memories: self)
    }
    
    
}
