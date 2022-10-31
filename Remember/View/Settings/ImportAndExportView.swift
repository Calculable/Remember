import Foundation
import SwiftUI


/// This view is part of the settings and allows the user to export their data as .json-File or import data from a .json-File
struct ImportAndExportView: View {
    
    @EnvironmentObject private var memories: Memories
    @State private var showDocumentPicker = false
    @State private var fileContent = ""
    
    var body: some View {
        Form {
            
            Section("Export memories") {
                let link = memories.getSavePath()
                ShareLink(item: link, message: Text("Export memories"))
  
            }
            
            Section("Import memories") {
                
                Text(fileContent).padding()
                
                Button("Import memories") {
                    showDocumentPicker = true
                }.sheet (isPresented: self.$showDocumentPicker) {
                    DocumentPicker(fileContent:$fileContent)
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
