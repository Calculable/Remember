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

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var memories: Memories
    @StateObject private var viewModel: ViewModel = ViewModel()

    init(toEdit memory: Memory? = nil, onMemoryUpdated: ((Memory) -> Void)? = nil) {
        _viewModel = StateObject<EditMemoryView.ViewModel>(wrappedValue: ViewModel(memory, onMemoryUpdated: onMemoryUpdated))
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
                    }
                            .sheet(isPresented: $viewModel.showingImagePicker) {
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

                    }
                            .sheet(isPresented: $viewModel.showingMapPicker, onDismiss: { viewModel.isCustomCoordinate = true }) {
                                NavigationView {

                                    // Just put the view into a sheet or navigation link
                                    LocationPicker(instructions: String(localized: "Tap on the map to select your coordinates"), coordinates: $viewModel.coordinate)
                                            .navigationBarItems(leading: Button(action: {
                                                viewModel.showingMapPicker = false
                                            }, label: {
                                                Text("Close").foregroundColor(.red)
                                            }))


                                }
                                        .navigationViewStyle(.stack)
                            }

                    if (viewModel.isCustomCoordinate) {
                        Text("\(viewModel.coordinate.latitude) / \(viewModel.coordinate.longitude)")
                        Button("Remove location", role: .destructive) {
                            viewModel.isCustomCoordinate = false
                        }
                    }
                }

                Section("Notifications") {

                    Toggle(isOn: $viewModel.notificationsEnabled) {
                        Text("Enable yearly notifications")
                    }


                }

                Section("Notes (Optional)") {
                    TextEditor(text: $viewModel.notes)
                            .frame(minHeight: 200)
                }

            }
                    .navigationBarTitle(Text(viewModel.existingMemory == nil ? "Add New Memory" : "Edit Memory"), displayMode: .inline)
                    .navigationBarItems(trailing:
                    Button("Save", action: {
                        viewModel.saveNewMemory(memories: memories)
                        dismiss()
                    })
                            .disabled(viewModel.saveDisabled)
                    )
        }
    }


}

struct EditMemoryView_Previews: PreviewProvider {
    static var previews: some View {

        let memories = Memories()
        EditMemoryView(toEdit: memories.memories.first!)
                .environmentObject(memories)
    }
}

