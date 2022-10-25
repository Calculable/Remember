//
//  LockView.swift
//  Remember
//
//  Created by Jan Huber on 19.08.22.
//

import SwiftUI

struct LockView: View {

    var unlockAction: () -> Void

    var body: some View {

        NavigationView {

            Button("Unlock", action: unlockAction)

        }
        .onAppear(perform: unlockAction)

    }
}
