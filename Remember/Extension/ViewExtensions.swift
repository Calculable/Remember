//
//  ViewExtensions.swift
//  Remember
//
//  Created by Jan Huber on 19.08.22.
//

import SwiftUI
//source: https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image

extension View {
    func snapshot(width: Int, height: Int) -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = CGSize(width: width, height: height)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
    
    @ViewBuilder func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}



