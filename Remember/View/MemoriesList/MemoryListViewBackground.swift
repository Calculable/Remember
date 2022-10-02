//
//  MemoryListViewBackground.swift
//  Remember
//
//  Created by Jan Huber on 02.10.22.
//

import Foundation
import SwiftUI




func getListBackground(memory: Memory, withReducedTransparency reducedTransparency: Bool = false) -> AnyView {
    
    if (memory.displayImage != nil && !reducedTransparency) {
        //use image as background
        return AnyView(
            
            ZStack {
                memory.displayImage!.resizable().scaledToFill().opacity(1)
                Rectangle()
                       .fill(Color.black.opacity(0.5))
            }
        
        );
        //return AnyView(Color(uiColor: UIColor.darkGray))

    } else {
        return AnyView(Color(uiColor: UIColor.darkGray))
    }

}
