//
//  StringTests.swift
//  FishTests
//
//  Created by Vyacheslav Khorkov on 24.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Fish
import XCTest

final class StringTests: XCTestCase {

    func test_relativePathTo() {
        XCTAssertEqual("/Users/some/Rugby".relativePath(to: "/Users/some"), "Rugby")
        XCTAssertEqual("/Users/some/Rugby".relativePath(to: "/Users/some/"), "Rugby")
        XCTAssertEqual("/Users/some/Rugby".relativePath(to: "/some/"), "/Users/some/Rugby")
    }
}
