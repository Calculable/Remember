//
//  AddMemoryView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI
import LocationPicker
import MapKit

struct AddMemoryView: View {
    
    @EnvironmentObject var memories: Memories

    
    @Environment(\.dismiss) var dismiss
    
    
    @State private var isCustomCoordinate = false
    @State private var coordinate = CLLocationCoordinate2D(latitude: 46.818188, longitude: 8.227512)
    
    @State private var showingMapPicker = false
    
    @State private var name: String = ""
    @State private var date: Date = Date.now
    
    @State private var image: Image?
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    
    
    var body: some View {
        
        NavigationView {
            Form {
                Section("General Inforamation") {
                    TextField("Title", text: $name)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
                
                Section("Image") {
                    Button("Select Image") {
                        showingImagePicker = true
                    }        .sheet(isPresented: $showingImagePicker) {
                        ImagePicker(image: $inputImage)
                    }.onChange(of: inputImage) { _ in loadImage() }
                    
                    
                    if let image = image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                        
                        Button("Remove image", role: .destructive) {
                            self.image = nil
                        }
                    }
                    
                }
                
                Section("Location") {
                    Button("Select location") {
                        showingMapPicker = true
                        
                    }.sheet(isPresented: $showingMapPicker, onDismiss: {isCustomCoordinate = true}) {
                        NavigationView {
                            
                            // Just put the view into a sheet or navigation link
                            LocationPicker(instructions: "Tap somewhere to select your coordinates", coordinates: $coordinate)

                            
                                .navigationBarItems(leading: Button(action: {
                                    showingMapPicker = false
                                }, label: {
                                    Text("Close").foregroundColor(.red)
                                }))
                        }
                    }
                    
                    if (isCustomCoordinate) {
                        Text("\(coordinate.latitude) / \(coordinate.longitude)")
                        
                        Button("Remove location", role: .destructive) {
                            isCustomCoordinate = false
                        }
                    }
                    
                }
                
                
                
            }
            .navigationBarTitle(Text("Add New Memory"), displayMode: .inline)
            .navigationBarItems(trailing: Button("Save", action: {
                
                let customCoordinate = isCustomCoordinate ? coordinate : nil
                let newMemory = Memory(name: name, date: date, image: image, coordinate: customCoordinate)
                memories.addMemory(newMemory)
                
                dismiss()
            }).disabled(name.isEmpty)
                                
            )
        }
        
        
        
        
        
        
        
        
        
    }
    
    //hier wandelt man das geladene `UIImage` wieder in ein `Image` um:
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct AddMemoryView_Previews: PreviewProvider {
    static var previews: some View {
        
        let memories = Memories()
        AddMemoryView()
            .environmentObject(memories)
    }
}

