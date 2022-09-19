//
//  MapView.swift
//  Remember
//
//  Created by Jan Huber on 19.09.22.
//

import Foundation


import SwiftUI
import MapKit

struct MapView: View {
        
    //@State private var mapRegion:MKCoordinateRegion
    @EnvironmentObject var memories: Memories
    
    @State private var mapRegion = MKCoordinateRegion(MKMapRect
        .world)
    
    

    
        
    var body: some View {
        
        let memoriesWithMapLocaiton = memories.memories.filter {$0.coordinate != nil}
        
        Map(coordinateRegion: $mapRegion, annotationItems: memoriesWithMapLocaiton) { memory in
            MapMarker(coordinate: memory.coordinate!)
        }
        
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(Memories())
    }
}
