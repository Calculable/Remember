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
    @Environment(\.accessibilityReduceTransparency)  var reduceTransparency
    
    @State private var mapRegion = MKCoordinateRegion(MKMapRect
        .world)
    @State private var selectedMemory: Memory? = nil
    
    
    func selectMemory(memory: Memory) {
        selectedMemory = memory
    }
    
    
    var body: some View {
        
        let memoriesWithMapLocation = memories.memoriesWithMapLocation
        
        Map(coordinateRegion: $mapRegion, annotationItems: memoriesWithMapLocation) { memory in
            
            MapAnnotation(coordinate: memory.coordinate!) {
                VStack{
                    Text(memory.name)
                        .font(.footnote)
                        .padding(5)
                        

                        .background(Color.background)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .opacity(reduceTransparency ? 1.0 : 0.9)
                
                    
                    Image(systemName: "mappin.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.background)
                        .opacity(reduceTransparency ? 1.0 : 0.9)
                    
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
