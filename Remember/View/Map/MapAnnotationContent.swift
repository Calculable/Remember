import Foundation
import SwiftUI


/// Represents the map annotation for a single memory
struct MapAnnotationContent: View {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency
    @State var title: String
    
    var body: some View {
        Text(title)
            .font(.footnote)
            .padding(5)
            .background(Color.background)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(reduceTransparency ? 1.0 : 0.9)
        
        Image(systemName: "mappin.circle.fill")
            .font(.largeTitle)
            .foregroundColor(.background)
            .opacity(reduceTransparency ? 1.0 : 0.9)
    }
}
