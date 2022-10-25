//
//  RememberApp.swift
//  Remember
//
//  Created by Jan Huber on 15.08.22.
//

import SwiftUI

@main
struct RememberApp: App {


    init() {
        #if DEBUG
        var injectionBundlePath = "/Applications/InjectionIII.app/Contents/Resources"
        #if targetEnvironment(macCatalyst)
        injectionBundlePath = "\(injectionBundlePath)/macOSInjection.bundle"
        #elseif os(iOS)
        injectionBundlePath = "\(injectionBundlePath)/iOSInjection.bundle"
        #endif
        Bundle(path: injectionBundlePath)?.load()
        #endif
    }


    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
