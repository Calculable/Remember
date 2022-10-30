import Foundation
import SwiftUI
import MapKit

/// A memory represents an event that occured some day in the past. Each memory has at least a title and a date. Additional information like a location, image or custom notes can be added as well
class Memory: Identifiable, ObservableObject, Comparable, Codable {
    
    let memoryIOHelper = MemoryIOHelper()
    
    
    /// a random identifier for the memories (added to be conform with the identifiable protocol that is required by Swift UI in some places)
    @Published var id = UUID()
    
    /// Title of the memory. For example "Invention of the World Wide Web"
    @Published var name: String
    
    /// Date on which the event / memory occured
    @Published var date: Date
    
    /// An optional background-image for the memory. The image automatically gets saved and deleted if this field is changed.
    @Published var image: UIImage? {
        didSet {
            if image == nil {
                memoryIOHelper.deleteImageInDocumentDirectory(forMemory: self)
                
            } else {
                memoryIOHelper.saveImageInDocumentDirectory(forMemory: self)
            }
        }
    }
    
    /// Optional additional notes about the memory
    @Published var notes: String
    
    
    /// If notifications are enabled, the user receives a local notification before each annivesary of a memory
    @Published var notificationsEnabled = false
    
    /// Used to show the memory location on a map
    @Published private var latitude: Double?
    
    /// Used to show the memory location on a map
    @Published private var longitude: Double?
    
    /// Memories marked for deletion are not shown in the main list of memories but can still be restored under "deleted memories"
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
