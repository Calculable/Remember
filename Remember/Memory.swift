//
//  Memory.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import Foundation
import SwiftUI
import MapKit

class Memory: Identifiable, ObservableObject {

    
    var id = UUID()
    var name: String
    var date: Date
    var image: Image?
    var coordinate: CLLocationCoordinate2D?
    
    init(name: String, date: Date = Date.now) {
        self.name = name
        self.date = date
    }
    
    convenience init(name: String, date: Date, image: Image? = nil, coordinate: CLLocationCoordinate2D? = nil) {
        self.init(name: name, date: date)
        self.image = image
        self.coordinate = coordinate
    }
    
    
}
