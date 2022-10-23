//
//  MapAnnotationContent.swift
//  Remember
//
//  Created by Jan Huber on 23.10.22.
//

import Foundation
import SwiftUI

struct MapAnnotationContent: View {
    @Environment(\.accessibilityReduceTransparency)  var reduceTransparency

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
