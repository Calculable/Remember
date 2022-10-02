//
//  EditMemoryView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI
import LocationPicker
import MapKit

struct EditMemoryView: View {
    
    @StateObject private var viewModel: ViewModel = ViewModel()

    @EnvironmentObject var memories: Memories
    @Environment(\.dismiss) var dismiss
    
    private var existingMemory: Memory? = nil
    
    init() {
    }
    
    init(toEdit memory: Memory) {
        _viewModel = StateObject<EditMemoryView.ViewModel>(wrappedValue: ViewModel(memory))
        existingMemory = memory
    }
    
    var body: some View {
        
        NavigationView {
            Form {
                Section("General Inforamation") {
                    TextField("Title", text: $viewModel.name)
                    DatePicker("Date", selection: $viewModel.date, displayedComponents: .date)
                }
                
                Section("Image (Optional)") {
                    Button("Select Image") {
                        viewModel.showImagePicker()
                    }.sheet(isPresented: $viewModel.showingImagePicker) {
                        ImagePicker(image: $viewModel.image)
                    }
                    
                    
                    if let image = viewModel.displayImage {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .accessibilityHint("The image you chose for this memory")
                        
                        Button("Remove image", role: .destructive) {
                            viewModel.removeImage()
                        }
                    }
                    
                }
                
                Section("Location (Optional)") {
                    Button("Select location") {
                        viewModel.showMapPicker()
                        
                    }.sheet(isPresented: $viewModel.showingMapPicker, onDismiss: {viewModel.isCustomCoordinate = true}) {
                        NavigationView {
                            
                            // Just put the view into a sheet or navigation link
                            LocationPicker(instructions: "Tap somewhere to select your coordinates", coordinates: $viewModel.coordinate)
                                .navigationBarItems(leading: Button(action: {
                                    viewModel.showingMapPicker = false
                                }, label: {
                                    Text("Close").foregroundColor(.red)
                                }))
                        }
                    }
                    
                    if (viewModel.isCustomCoordinate) {
                        Text("\(viewModel.coordinate.latitude) / \(viewModel.coordinate.longitude)")
                        Button("Remove location", role: .destructive) {
                            viewModel.isCustomCoordinate = false
                        }
                    }
                }
                
                Section("Notifications") {
                    
                    Toggle(isOn: $viewModel.notificationsEnabled){
                             Text("Enable yearly notifications")
                    }
                    
                    
                
                }
                
                Section("Notes (Optional)") {
                    TextEditor(text: $viewModel.notes)
                        .frame(minHeight: 200)
                }
                
            }
            .navigationBarTitle(Text(existingMemory == nil ? "Add New Memory" : "Edit Memory"), displayMode: .inline)
            .navigationBarItems(trailing:
                Button("Save", action: saveNewMemory)
                    .disabled(viewModel.saveDisabled)
            )
        }
    }
    
    func saveNewMemory() {
        
        if let memory = existingMemory {
            memories.remove(memory)
        }
        
        let customCoordinate = viewModel.isCustomCoordinate ? viewModel.coordinate : nil
        let newMemory = Memory(name: viewModel.name, date: viewModel.date, image: viewModel.image, coordinate: customCoordinate, notes: viewModel.notes, notificationsEnabled: viewModel.notificationsEnabled)
        memories.addMemory(newMemory)
        dismiss()
    }
}

struct EditMemoryView_Previews: PreviewProvider {
    static var previews: some View {
        
        let memories = Memories()
        EditMemoryView()
            .environmentObject(memories)
    }
}

