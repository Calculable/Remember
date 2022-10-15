//
//  MemoryListEntryView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//


import SwiftUI

struct MemoryListEntryView: View {
        
    @StateObject var memory: Memory
    var showNotificationSymbol: Bool = true

    var body: some View {
        
        VStack(alignment: .leading) {
            
                     
            Group {
                Text(memory.name)
                .font(.title2)
                .fontWeight(.bold)

                Text(memory.date.formatted(date: .long, time: .omitted))
                    .foregroundColor(.white).padding([.top, .bottom], 6)
                
            }.accessibilityElement(children: .combine)

            if (showNotificationSymbol) {
                Image(systemName: memory.notificationsEnabled ? "bell.fill" : "bell.slash")
                    .foregroundColor(.white)
                    .accessibilityLabel(memory.notificationsEnabled ? "yearly notifications are enabled for this memory" : "yearly notifications are disabled for this memory")
            }




            
        }

            .foregroundColor(.white)

    }
    

}

struct MemoryListEntryView_Previews: PreviewProvider {
    static var previews: some View {
        let exampleMemory = Memory(name: "Example Memory")
        MemoryListEntryView(memory: exampleMemory)
    }
}

