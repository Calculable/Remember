//
//  UpcomingMemoriesView.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

struct UpcomingMemoriesView: View {
    
    @ObservedObject var model: Memories
    
    var body: some View {
        
        Text("Upcoming")
        
    }
}

struct UpcomingMemoriesView_Previews: PreviewProvider {
    static var previews: some View {
        let memories = Memories()
        memories.loadExampleMemories()
        return UpcomingMemoriesView(model: memories)
    }
}

