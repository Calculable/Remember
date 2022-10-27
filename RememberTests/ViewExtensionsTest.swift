//
//  ViewExtensionsTest.swift
//  RememberTests
//
//  Created by Jan Huber on 17.10.22.
//

import XCTest

@testable
import Remember
import SwiftUI

class ViewExtensionsTests: XCTestCase {
    
    func testCanTakeSnapshotOfView() {
        let exampleView = Color.red
        let snapshot = exampleView.snapshot(width: 200, height: 100)
        XCTAssert(snapshot.size.width == 200)
        XCTAssert(snapshot.size.height == 100)
    }
}

