//
//  Memory.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import Foundation
import SwiftUI
import MapKit

class Memory: Identifiable, ObservableObject, Comparable, Codable {
    
    let memoryIOHelper = MemoryIOHelper()
    @Published var id = UUID()
    @Published var name: String
    @Published var date: Date
    @Published var image: UIImage? {
        didSet {
            if image == nil {
                memoryIOHelper.deleteImageInDocumentDirectory(forMemory: self)
                
            } else {
                memoryIOHelper.saveImageInDocumentDirectory(forMemory: self)
            }
        }
    }
    
    @Published var notes: String
    @Published var notificationsEnabled = false
    @Published private var latitude: Double?
    @Published private var longitude: Double?
    @Published var isMarkedForDeletion: Bool = false
    
    var coordinate: CLLocationCoordinate2D? {
        get {
            guard let latitude = latitude else {
                return nil
            }
            
            guard let longitude = longitude else {
                return nil
            }
            
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
        
        set {
            latitude = newValue?.latitude
            longitude = newValue?.longitude
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, date, latitude, longitude, notificationsEnabled, notes, isMarkedForDeletion
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(date, forKey: .date)
        try container.encode(notificationsEnabled, forKey: .notificationsEnabled)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(notes, forKey: .notes)
        try container.encode(isMarkedForDeletion, forKey: .isMarkedForDeletion)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        date = try container.decode(Date.self, forKey: .date)
        notificationsEnabled = try container.decode(Bool.self, forKey: .notificationsEnabled)
        latitude = try container.decode(Double?.self, forKey: .latitude)
        longitude = try container.decode(Double?.self, forKey: .longitude)
        notes = try container.decode(String.self, forKey: .notes)
        isMarkedForDeletion = try container.decode(Bool.self, forKey: .isMarkedForDeletion)
        image = memoryIOHelper.loadImageFromDocumentDirectory(forMemory: self)
    }
    
    init(name: String, date: Date = Date.now) {
        self.name = name
        self.date = date
        self.notes = ""
    }
    
    convenience init(name: String, date: Date, image: UIImage? = nil, coordinate: CLLocationCoordinate2D? = nil, notes: String = "", notificationsEnabled: Bool) {
        self.init(name: name, date: date)
        self.image = image
        self.coordinate = coordinate
        self.notes = notes
        self.notificationsEnabled = notificationsEnabled
    }
    
    static func ==(lhs: Memory, rhs: Memory) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func <(lhs: Memory, rhs: Memory) -> Bool {
        return lhs.date < rhs.date
    }
}
