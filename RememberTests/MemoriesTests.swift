//
//  MemoriesTests.swift
//  RememberTests
//
//  Created by Jan Huber on 17.10.22.
//

import XCTest

@testable
import Remember

class NotificationHelperSpy: NotificationHelper {
    
    var memoriesWithRemovedNotifications: [Memory] = []
    var numberOfNotificationUpdates = 0
    
    
    override func removeNotification(forMemory memory: Memory) {
        memoriesWithRemovedNotifications.append(memory)
    }
    
    override func updateNotifications(forMemories memories: Memories) {
        numberOfNotificationUpdates += 1
    }
    
    func notificationsWereRemoved(for memory: Memory) -> Bool {
        return memoriesWithRemovedNotifications.contains(memory)
    }
    
    func notificationsWereUpdated() -> Bool {
        return numberOfNotificationUpdates > 0
    }
    
}

class MemoriesIOHelperMock: MemoryIOHelper {
    
    override func saveMemories(_ memories: [Memory]) {
    }
    
    
    override func loadMemoriesFromDisk() -> [Memory] {
        return []
    }
}


class MemoriesTests: XCTestCase {
    
    var subject: Memories!
    var notificationHelperSty = NotificationHelperSpy()
    var ioHelperMock = MemoriesIOHelperMock()
    
    
    override func setUp() {
        subject = Memories(notificationHelper: notificationHelperSty, memoryIOHelper: ioHelperMock)
        subject.addExampleMemories()
    }
    
    override func tearDown() {
        subject = nil
    }
    
    func testExampleMemoriesAreAddedByDefault() {
        XCTAssert(!subject.memories.isEmpty)
    }
    
    func testNewMemoryCanBeAdded() {
        let amountOfMemoriesBefore = subject.memories.count
        let newMemory = Memory(name: "New Memory")
        subject.addMemory(newMemory)
        let amountOfMemoriesAfter = subject.memories.count
        
        XCTAssert(amountOfMemoriesAfter == amountOfMemoriesBefore + 1)
        XCTAssert(!subject.memories.isEmpty)
        XCTAssert(notificationHelperSty.notificationsWereUpdated())
    }
    
    func testMemoriesAreSortedByDate() {
        for memory in subject.memories {
            subject.remove(memory)
        }
        subject.addMemory(Memory(name: "B Second", date: Date(day: 5, month: 10, year: 2020)))
        subject.addMemory(Memory(name: "C Third", date: Date(day: 5, month: 10, year: 2019)))
        subject.addMemory(Memory(name: "A First", date: Date(day: 5, month: 10, year: 2021)))
        
        XCTAssert(subject.memories[0].name == "A First")
        XCTAssert(subject.memories[1].name == "B Second")
        XCTAssert(subject.memories[2].name == "C Third")
    }
    
    func testMemoriesCanBeMarkedForDeletion() {
        let amountOfAvailableMemories = subject.availableMemories.count
        let memoryToDelete = subject.memories.first!
        subject.markForDeletion(memoryToDelete)
        XCTAssert(subject.memoriesMarkedForDeletion.count == 1)
        XCTAssert(subject.availableMemories.count == amountOfAvailableMemories - 1)
        XCTAssert(notificationHelperSty.notificationsWereRemoved(for: memoryToDelete))
    }
    
    func testExampleMemoriesCanBeAdded() {
        for memory in subject.memories {
            subject.remove(memory)
        }
        subject.addExampleMemories()
        
        XCTAssert(subject.availableMemories.count > 0)
    }
    
    func testMemoryMarkedForDeletionCanBeRestored() {
        let amountOfAvailableMemories = subject.availableMemories.count
        let memory = subject.memories.first!
        subject.markForDeletion(memory)
        subject.restore(memory)
        XCTAssert(subject.memoriesMarkedForDeletion.count == 0)
        XCTAssert(subject.availableMemories.count == amountOfAvailableMemories)
        XCTAssert(notificationHelperSty.notificationsWereUpdated())
    }
    
    func testMemoryMarkedForDeletionCanBeFinallyDeleted() {
        let amountOfMemories = subject.memories.count
        let memory = subject.memories.first!
        subject.markForDeletion(memory)
        XCTAssert(subject.memories.count == amountOfMemories)
        subject.deleteMarkedMemories()
        XCTAssert(subject.memories.count == amountOfMemories - 1)
    }
    
    func testMemoryCanBeDeletedDirectly() {
        let amountOfMemories = subject.memories.count
        let memory = subject.memories.first!
        subject.remove(memory)
        XCTAssert(subject.memories.count == amountOfMemories - 1)
        XCTAssert(notificationHelperSty.notificationsWereRemoved(for: memory))
    }
    
    func testNotificationSettingsCanBeToggledForMemory() {
        let memory = subject.memories.first!
        XCTAssert(!memory.notificationsEnabled)
        subject.toggleNotifications(for: memory)
        XCTAssert(memory.notificationsEnabled)
        subject.toggleNotifications(for: memory)
        XCTAssert(!memory.notificationsEnabled)
        XCTAssert(notificationHelperSty.notificationsWereUpdated())
    }
    
    func testNewestYearCanBeExtractedFromMemories() {
        for memory in subject.memories {
            subject.remove(memory)
        }
        
        subject.addMemory(Memory(name: "A", date: Date(day: 1, month: 10, year: 1999)))
        subject.addMemory(Memory(name: "B", date: Date(day: 6, month: 6, year: 2015)))
        subject.addMemory(Memory(name: "C", date: Date(day: 3, month: 7, year: 1998)))
        subject.addMemory(Memory(name: "C", date: Date(day: 5, month: 2, year: 2017)))
        
        XCTAssert(subject.newestYear() == 2017)
    }
    
    func testOldestYearCanBeExtractedFromMemories() {
        for memory in subject.memories {
            subject.remove(memory)
        }
        subject.addMemory(Memory(name: "A", date: Date(day: 14, month: 7, year: 1999)))
        subject.addMemory(Memory(name: "B", date: Date(day: 5, month: 3, year: 2015)))
        subject.addMemory(Memory(name: "C", date: Date(day: 7, month: 7, year: 1998)))
        subject.addMemory(Memory(name: "D", date: Date(day: 2, month: 1, year: 2017)))
        
        XCTAssert(subject.oldestYear() == 1998)
    }
    
    func testMemoriesForASpecificYearCanBeReturned() {
        subject.removeAllMemories()
        let a = Memory(name: "A", date: Date(day: 29, month: 3, year: 1999))
        let b = Memory(name: "B", date: Date(day: 5, month: 5, year: 2000))
        let c = Memory(name: "C", date: Date(day: 7, month: 2, year: 2000))
        let d = Memory(name: "D", date: Date(day: 8, month: 8, year: 2000))
        let e = Memory(name: "E", date: Date(day: 12, month: 10, year: 2003))
        let f = Memory(name: "F", date: Date(day: 15, month: 11, year: 2005))
        
        subject.addMemory(a)
        subject.addMemory(b)
        subject.addMemory(c)
        subject.addMemory(d)
        subject.addMemory(e)
        subject.addMemory(f)
    
        let memoriesFromYear2000 = subject.memoriesForYear(2000)
        XCTAssert(memoriesFromYear2000.count == 3)
        XCTAssert(memoriesFromYear2000[0] == d)
        XCTAssert(memoriesFromYear2000[1] == b)
        XCTAssert(memoriesFromYear2000[2] == c)
    }
}
