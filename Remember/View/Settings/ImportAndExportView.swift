import Foundation
import SwiftUI


/// This view is part of the settings and allows the user to export their data as .json-File or import data from a .json-File
struct ImportAndExportView: View {
    
    @EnvironmentObject private var memories: Memories
    @State private var showDocumentPicker = false
    @State private var fileContent = ""
    @State private var successfullyImportedMemories: Int? = nil
    @State private var showImportErrorAlert = false
    @State private var showImportSuccessAlert = false

    var body: some View {
        Form {
            
            Section("Export memories") {
                let link = memories.getSavePath()
                ShareLink("Export memories", item: link)
            }
            
            Section("Import memories") {
                Button("Import memories") {
                    showDocumentPicker = true
                }.sheet (isPresented: self.$showDocumentPicker) {
                    DocumentPicker(fileContent:$fileContent)
                }.onChange(of: fileContent, perform: { newFileContent in
                    do {
                        successfullyImportedMemories = try memories.importFromJSONString(content: newFileContent)
                        showImportSuccessAlert = true
                    } catch {
                        print(error.localizedDescription)
                        showImportErrorAlert = true
                        successfullyImportedMemories = nil
                    }
                    
                }).alert("Import successful", isPresented: $showImportSuccessAlert, presenting: successfullyImportedMemories) { amountOfNewMemories in
                    Button("OK", role: .cancel) { }
                } message: { amountOfNewMemories in
                    Text(String(format: NSLocalizedString("%d new memories were imported", comment: "amount of imported memories"), amountOfNewMemories))
                }.alert("Import failed", isPresented: $showImportErrorAlert) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("The input-data does not have the required format.")
                }
            }
            
        }
        .navigationTitle("Import and Export").navigationBarTitleDisplayMode(.inline)
    }
    
}

struct ImportAndExportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportAndExportView()
    }
}
