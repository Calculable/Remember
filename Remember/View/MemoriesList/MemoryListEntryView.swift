import SwiftUI


/// Represents a single list item in the list of memories from the MemoriesListView
struct MemoryListEntryView: View {
    
    @ObservedObject var memory: Memory
    var showNotificationSymbol: Bool = true
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Group {
                Text(memory.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(memory.date.formatted(date: .long, time: .omitted))
                    .foregroundColor(.white).padding([.top, .bottom], 6)
            }
            .accessibilityElement(children: .combine)
            
            if (showNotificationSymbol) {
                Image(systemName: memory.notificationsEnabled ? "bell.fill" : "bell.slash")
                    .foregroundColor(.white)
                    .accessibilityLabel(memory.notificationsEnabled ? String(localized: "yearly notifications are enabled for this memory") : String(localized: "yearly notifications are disabled for this memory"))
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

