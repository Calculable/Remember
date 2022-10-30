import Foundation
import UIKit
import MapKit


/// Manages the data of the application. Contains a sequence of memory items and provices functionality to save, load, filter edit delete or restore memories. A single instance of this class is accessible for the View's as EnvironmentObject
class Memories: ObservableObject {
    
    @Published private(set) var memories: [Memory] = []
    let notificationHelper: NotificationHelper
    let memoryIOHelper: MemoryIOHelper
    
    /// memories that are not marked for deletion
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
    
    var memoriesWithMapLocation: [Memory] {
        availableMemories.filter {
            $0.coordinate != nil
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
    
    func removeAllMemories() {
        memories = []
        addExampleMemories()
    }
    
    func markForDeletion(_ memory: Memory) {
        objectWillChange.send()
        notificationHelper.removeNotification(forMemory: memory) //redundant because all notifications get recreated on save
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
        notificationHelper.removeNotification(forMemory: memory) //redundant because all notifications get recreated on save
        memory.image = nil //triggers deletion of the image
        memories.remove(at: memories.firstIndex(of: memory)!)
        save()
    }
    
    
    func toggleNotifications(for memory: Memory) {objectWillChange.send()
        objectWillChange.send()
        memory.notificationsEnabled.toggle()
        save()
    }
    
    var newestYear: Int? {
        return availableMemories.map({ memory in memory.date.year() }).max(); ///year of the most recent memory
    }
    
    var oldestYear: Int? {
        return availableMemories.map({ memory in memory.date.year() }).min(); ///year of the most recent memory
    }
    
    func memoriesForYear(_ year: Int) -> [Memory] {
        return availableMemories.filter { memory in
            return memory.date.year() == year;
        }
    }
    
    func filteredMemories(searchText: String) -> [Memory] {
        if searchText.isEmpty {
            return availableMemories
        } else {
            return availableMemories.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    /// Store the memories on the disk
    private func save() {
        memoryIOHelper.saveMemories(memories)
        notificationHelper.updateNotifications(forMemories: self)
        
    }
    
    private func sortMemories() {
        memories.sort()
        memories.reverse()
    }
}
