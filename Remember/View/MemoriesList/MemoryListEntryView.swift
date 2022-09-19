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
            
                        
                Text(memory.name)
                .font(.title2)
                .fontWeight(.bold)


            
                
            
            Text(memory.date.formatted(date: .long, time: .omitted))
                .foregroundColor(.white).padding([.top, .bottom], 6)

            Image(systemName: memory.notificationsEnabled ? "bell.fill" : "bell.slash")
                .foregroundColor(.white)



            
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

