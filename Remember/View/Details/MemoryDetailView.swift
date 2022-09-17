//
//  MemoryDetailView.swift
//  Remember
//
//  Created by Jan Huber on 16.09.22.
//

import SwiftUI
import MapKit

struct MemoryDetailView: View {
    
    @State var memory: Memory
    
    @State private var mapRegion:MKCoordinateRegion
    

    init(memory: Memory) {
        self.memory = memory
        self.mapRegion =  MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: memory.coordinate?.latitude ?? 0, longitude: memory.coordinate?.longitude ?? 0), span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
    }
    
        
    var body: some View {
        VStack {
            Text(memory.name).font(.largeTitle)
            Text(memory.date.formatted(date: .long, time: .omitted))
                .foregroundColor(.secondary)
            
            if let image = memory.displayImage {
                AnyView(image.resizable().scaledToFit().frame(maxWidth: .infinity).clipped().opacity(0.3));
            }
            
            if memory.coordinate != nil {
                Map(coordinateRegion: $mapRegion, annotationItems: [memory]) { memory in
                    MapMarker(coordinate: memory.coordinate!)
                }
            }
            
            
            
            
            Spacer()
            
        }
        
    }
    
}

struct MemoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        let memory = Memory(name: "Moonlanding", date: Date(day: 16, month: 7, year: 1969), image: UIImage(named:"moon"), coordinate: CLLocationCoordinate2D(latitude: 47.35296, longitude: 8.78047))
        
        MemoryDetailView(memory: memory)
    }
}
