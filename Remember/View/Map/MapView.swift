import Foundation


import SwiftUI
import MapKit


/// Displays a map showing the location of all the memories
struct MapView: View {
    
    @EnvironmentObject private var memories: Memories
    @State private var mapRegion = MKCoordinateRegion(MKMapRect.world)
    @State private var selectedMemory: Memory? = nil
    
    var body: some View {
        Map(coordinateRegion: $mapRegion, annotationItems: memories.memoriesWithMapLocation) { memory in
            MapAnnotation(coordinate: memory.coordinate!) {
                VStack {
                    MapAnnotationContent(title: memory.name)
                }
                .onTapGesture {
                    select(memory: memory)
                }
            }
        }
        .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        .sheet(item: $selectedMemory) { memory in
            MemoryDetailView(memory: memory)
        }
        .edgesIgnoringSafeArea([.top])
    }
    
    private func select(memory: Memory) {
        selectedMemory = memory //shows details for the selected memory
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(Memories())
    }
}
