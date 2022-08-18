//
//  MemoryListEntryView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//


import SwiftUI

struct MemoryListEntryView: View {
    
    @StateObject var memory: Memory
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            HStack {
                Image(systemName: memory.notificationsEnabled ? "bell.fill" : "bell.slash")
                Text(memory.name)
            }
            
            Text(memory.date.formatted(date: .long, time: .omitted))
                .foregroundColor(.secondary)
            
        }.listRowBackground(getListBackground()).frame(minHeight: 100)
        
    }
    
    func getListBackground() -> AnyView {
        if let image = memory.displayImage {
            return AnyView(image.resizable().scaledToFill().frame(height: 100).clipped().opacity(0.3));
        } else {
            return AnyView(Color(uiColor: UIColor.systemBackground));
        }
    }
}

struct MemoryListEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleMemory = Memory(name: "Example Memory")
        MemoryListEntryView(memory: exampleMemory)
    }
}

