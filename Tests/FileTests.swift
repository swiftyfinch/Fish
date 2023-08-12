//
//  FileTests.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 13.08.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Fish
import XCTest

final class FileTests: XCTestCase {

    private let fileManager = FileManager.default
    private var testsFolder: IFolder!

    override func setUp() async throws {
        try await super.setUp()
        let tmp = fileManager.temporaryDirectory
        let testsFolderURL = tmp.appendingPathComponent(.fake)
        testsFolder = try Folder.create(at: testsFolderURL.path)
    }

    override func tearDown() async throws {
        try await super.tearDown()
        try testsFolder.delete()
    }
}

// MARK: - Tests

extension FileTests {
    func test_isExist() throws {
        let path = testsFolder.subpath(.fake)
        fileManager.createFile(atPath: path, contents: nil)

        // Act
        let isExist = File.isExist(at: path)

        // Assert
        XCTAssertTrue(isExist)
    }

    func test_at() throws {
        let path = testsFolder.subpath(.fake)
        fileManager.createFile(atPath: path, contents: nil)

        // Act
        let file = try File.at(path)

        // Assert
        XCTAssertEqual(file.path, path)
    }

    func test_at_error() throws {
        let path = testsFolder.subpath(.fake)

        // Act & Assert
        var error: Error?
        XCTAssertThrowsError(try File.at(path)) { error = $0 }
        XCTAssertEqual(error as? FishError, FishError.fileNotFound(path))
    }

    func test_create_empty() throws {
        let path = testsFolder.subpath(.fake)

        // Act
        try File.create(at: path)

        // Assert
        XCTAssertTrue(fileManager.fileExists(atPath: path))
    }

    func test_create_withContent() throws {
        let path = testsFolder.subpath(.fake)
        let content = String.fake

        // Act
        try File.create(at: path, contents: content)

        // Assert
        XCTAssertTrue(fileManager.fileExists(atPath: path))

        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let resultContent = String(data: data, encoding: .utf8)
        XCTAssertEqual(resultContent, content)
    }

    func test_delete() throws {
        let path = testsFolder.subpath(.fake)
        fileManager.createFile(atPath: path, contents: nil)

        // Act
        try File.delete(at: path)

        // Assert
        XCTAssertFalse(fileManager.fileExists(atPath: path))
    }

    func test_read() throws {
        let path = testsFolder.subpath(.fake)
        let content = String.fake
        let data = content.data(using: .utf8)
        fileManager.createFile(atPath: path, contents: data)

        // Act
        let resultContent = try File.read(at: path)

        // Assert
        XCTAssertEqual(resultContent, content)
    }
}
