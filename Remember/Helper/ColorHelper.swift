//
//  MemoryListViewBackground.swift
//  Remember
//
//  Created by Jan Huber on 02.10.22.
//

import Foundation
import SwiftUI

func getListBackground(memory: Memory, withReducedTransparency reducedTransparency: Bool = false, withIncreasedContrast increasedContrast: Bool = false) -> AnyView {
    
    if (memory.image != nil && !reducedTransparency) {
        //use image as background
        return AnyView(
            
            ZStack {
                Image(uiImage: memory.image!).resizable().scaledToFill().opacity(1)
                Rectangle()
                    .fill(Color.black.opacity(increasedContrast ? 0.8 : 0.5))
            }.accessibilityHidden(true)
        
        )
        //return AnyView(Color(uiColor: UIColor.darkGray))

    } else {
        return AnyView(Color(uiColor: UIColor.darkGray).accessibilityHidden(true))
    }

}