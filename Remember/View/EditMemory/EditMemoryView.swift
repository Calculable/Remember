import SwiftUI
import LocationPicker
import MapKit


/// Displays a form to edit an existing memory or create a new memory
struct EditMemoryView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var memories: Memories
    @StateObject private var viewModel: ViewModel = ViewModel()
    
    init(toEdit memory: Memory? = nil) {
        _viewModel = StateObject<EditMemoryView.ViewModel>(wrappedValue: ViewModel(memory))
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
                        ImagePicker(image: $viewModel.image, onError: {viewModel.showImageCannotBeLoadedErrorMessage()})
                    }
                    .alert("Error while loading image", isPresented: $viewModel.showingImageErrorMessage) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text("This type of image is not supported by the app.")
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
                    .sheet(isPresented: $viewModel.showingMapPicker, onDismiss: { viewModel.markAsCustomCoordinate() }) {
                        NavigationView {
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
                            viewModel.markAsNonCustomCoordinate()
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
                viewModel.saveMemory(memories: memories)
                dismiss()
            })
            .disabled(viewModel.saveDisabled))
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

