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

    var id = UUID()
    var name: String
    var date: Date
    var image: Image?
    
    private var latitude: Double?
    private var longitude: Double?
    
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
        case id, name, date, latitude, longitude
    }
    
    init(name: String, date: Date = Date.now) {
        self.name = name
        self.date = date
    }
    
    convenience init(name: String, date: Date, image: Image? = nil, coordinate: CLLocationCoordinate2D? = nil) {
        self.init(name: name, date: date)
        self.image = image
        self.coordinate = coordinate
    }
    
    static func == (lhs: Memory, rhs: Memory) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    static func < (lhs: Memory, rhs: Memory) -> Bool {
        return lhs.date < rhs.date
    }
    
    
}
