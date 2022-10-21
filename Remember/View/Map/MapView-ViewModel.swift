//
//  MapView-ViewModel.swift
//  Remember
//
//  Created by Jan Huber on 21.10.22.
//

import Foundation
import MapKit
import SwiftUI

extension MapView {
    @MainActor class ViewModel: ObservableObject {
        
        init() {
            
        }
        
        //@State private var mapRegion:MKCoordinateRegion
        @EnvironmentObject var memories: Memories

        @Published var mapRegion = MKCoordinateRegion(MKMapRect
            .world)
        @Published var selectedMemory: Memory? = nil
        
        @Environment(\.accessibilityReduceTransparency)  var reduceTransparency
        
        func selectMemory(memory: Memory) {
            selectedMemory = memory
        }
        
        var memoriesWithMapLocation: [Memory] {
            memories.availableMemories.filter {$0.coordinate != nil}
        }

    }
    
}
