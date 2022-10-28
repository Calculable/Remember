import Foundation
import SwiftUI


/// Generates a background image or color which is used for a list-entry representing a memory
/// - Parameters:
///   - memory: the memory for which the background is generated. If available, the stored image or the memory is used as background, otherwise a color is used
///   - reducedTransparency: indicates if the transparency should be reduced for accessibility
///   - increasedContrast: indicates if the contrast should be increased for accessibility
/// - Returns: the view to be used as background for a memory
func getListBackground(forMemory memory: Memory, withReducedTransparency reducedTransparency: Bool = false, withIncreasedContrast increasedContrast: Bool = false) -> AnyView {
    if (memory.image != nil && !reducedTransparency) {
        return AnyView(
            ZStack {
                Image(uiImage: memory.image!).resizable().scaledToFill().opacity(1)
                Rectangle()
                    .fill(Color.black.opacity(increasedContrast ? 0.8 : 0.5))
            }
            .accessibilityHidden(true))
    } else {
        return AnyView(Color(uiColor: UIColor.darkGray).accessibilityHidden(true))
    }
    
}
