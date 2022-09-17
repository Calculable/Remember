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
                    .font(.headline)
            }
            
            Text(memory.date.formatted(date: .long, time: .omitted))
               
            
        }
        
    }
    

}

struct MemoryListEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleMemory = Memory(name: "Example Memory")
        MemoryListEntryView(memory: exampleMemory)
    }
}

