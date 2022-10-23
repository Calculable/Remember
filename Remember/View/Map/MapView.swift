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
        
    @EnvironmentObject var memories: Memories
    
    @State private var mapRegion = MKCoordinateRegion(MKMapRect
        .world)
    @State private var selectedMemory: Memory? = nil
    
    
    func selectMemory(memory: Memory) {
        selectedMemory = memory
    }
    
    
    var body: some View {
        
        
        Map(coordinateRegion: $mapRegion, annotationItems: memories.memoriesWithMapLocation) { memory in
            
            MapAnnotation(coordinate: memory.coordinate!) {
                VStack{
                    
                    MapAnnotationContent(title: memory.name)
                    
                    
                }.onTapGesture {
                    selectMemory(memory: memory)
                }
                
            }

        }.dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            .sheet(item: $selectedMemory) { memory in
            MemoryDetailView(memory: memory)
        }.ignoresSafeArea()

        
        
    
        
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(Memories())
    }
}
