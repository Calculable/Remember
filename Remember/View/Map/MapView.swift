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
        
    @StateObject private var viewModel: ViewModel = ViewModel()

    var body: some View {
        
        let memoriesWithMapLocation = viewModel.memoriesWithMapLocation
        
        Map(coordinateRegion: $viewModel.mapRegion, annotationItems: memoriesWithMapLocation) { memory in
            
            MapAnnotation(coordinate: memory.coordinate!) {
                VStack{
                    Text(memory.name)
                        .font(.footnote)
                        .padding(5)
                        

                        .background(Color.background)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .opacity(viewModel.reduceTransparency ? 1.0 : 0.9)
                
                    
                    Image(systemName: "mappin.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.background)
                        .opacity(viewModel.reduceTransparency ? 1.0 : 0.9)
                    
                }.onTapGesture {
                    viewModel.selectMemory(memory: memory)
                }
                
            }

        }.dynamicTypeSize(...DynamicTypeSize.xxxLarge)
            .sheet(item: $viewModel.selectedMemory) { memory in
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
