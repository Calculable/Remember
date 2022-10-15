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
    @State private var selectedMemory: Memory? = nil


    
        
    var body: some View {
        
        let memoriesWithMapLocaiton = memories.memories.filter {$0.coordinate != nil}
        
        Map(coordinateRegion: $mapRegion, annotationItems: memoriesWithMapLocaiton) { memory in
            
            MapAnnotation(coordinate: memory.coordinate!) {
                VStack{
                    Text(memory.name)
                        .font(.footnote)
                        .padding(5)
                        

                        .background(Color.background)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .opacity(0.9)
                
                    
                    Image(systemName: "mappin.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.background)
                        .opacity(0.9)
                    
                }.onTapGesture {
                    selectedMemory = memory
                }
                
            }

        }.dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .sheet(item: $selectedMemory) { memory in
            MemoryDetailView(memory: memory)
        }

        
        
    
        
    }
    
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(Memories())
    }
}
