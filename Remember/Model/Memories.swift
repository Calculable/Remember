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
    
    func addMemories(_ newMemories: [Memory]) {
        for memory in newMemories {
            let memoryToImport = memory
            if (identifierExists(uuid: memoryToImport.id)) {
                //when the identifier exists, it means that this memory was likely exported before and is now imported again
                //there are multiple possibilities to handle this case:
                //  - skipping the import of this memory
                //  - "diff" the existing memory with the new memory and update the existing memory with the new information
                //  - throwing an error
                //  - assign a new unique id and import the memory
                //  - ask the user which option he/she wants to choose
                //currently,the memory gets a new unique id assigned and is then imported.
                memoryToImport.id = UUID()
            }
            memory.removeImage(deleteFromDisk: false)
            memories.append(memoryToImport)
        }
        sortMemories()
        save()
    }
    
    func identifierExists(uuid: UUID) -> Bool {
        return memories.contains(where: {
            $0.id == uuid
        })
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
    
    func remove(_ memory: Memory, deleteImageFromDisk: Bool = true) {
        notificationHelper.removeNotification(forMemory: memory) //redundant because all notifications get recreated on save
        if (deleteImageFromDisk) {
            memory.removeImage(deleteFromDisk: true)
        }
        memories.remove(at: memories.firstIndex(of: memory)!)
        save()
    }
    
    
    func toggleNotifications(for memory: Memory) {
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
    
    func memoryWasUpdated(_ memory: Memory, imageWasChanged: Bool) {
        objectWillChange.send()
        notificationHelper.removeNotification(forMemory: memory) //redundant because all notifications get recreated on save
        if (imageWasChanged) { //if the image was not changed, deleting and re-loading the file is avoided for performance reasons
            let imageBackup = memory.image
            memory.removeImage(deleteFromDisk: true)
            memory.image = imageBackup
            memory.saveImageToDisk()
        }
        save()
    }
    
    /// Returns the link to the .JSON-File that stores all memories
    func getSavePath() -> URL {
        return memoryIOHelper.getSavePath()
    }

    
    /// Imports new memories from a JSON-String
    /// - Parameter content: a JSON-String containing an encoded version of the memories
    /// - Returns: the amount of successfully imported memories.
    func importFromJSONString(content: String) throws -> Int  {
        let newMemories = try memoryIOHelper.loadMemoriesFromJSONString(jsonContent: content)
        addMemories(newMemories)
        return newMemories.count
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
