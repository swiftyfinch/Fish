//
//  FolderTests.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 13.08.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Fish
import XCTest

final class FolderTests: XCTestCase {

    private let fileManager = FileManager.default
    private var testsFolder: (any IFolder)!

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

extension FolderTests {
    func test_isFolder_true() throws {
        let path = testsFolder.subpath(.fake)
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false)

        // Act
        let isFolder = isFolder(at: path)

        // Assert
        XCTAssertTrue(isFolder)
    }

    func test_isFolder_false() throws {
        let path = testsFolder.subpath(.fake)
        fileManager.createFile(atPath: path, contents: nil)

        // Act
        let isFolder = isFolder(at: path)

        // Assert
        XCTAssertFalse(isFolder)
    }

    func test_current() {
        let currentFolderPath = Folder.current.path

        // Assert
        XCTAssertEqual(currentFolderPath, fileManager.currentDirectoryPath)
    }

    func test_home() {
        let currentFolderPath = Folder.home.path

        // Assert
        XCTAssertEqual(currentFolderPath, fileManager.homeDirectoryForCurrentUser.path)
    }

    func test_isExist() throws {
        let path = testsFolder.subpath(.fake)
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false)

        // Act
        let isExist = Folder.isExist(at: path)

        // Assert
        XCTAssertTrue(isExist)
    }

    func test_at() throws {
        let path = testsFolder.subpath(.fake)
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false)

        // Act
        let folder = try Folder.at(path)

        // Assert
        XCTAssertEqual(folder.path, path)
    }

    func test_at_error() throws {
        let path = testsFolder.subpath(.fake)

        // Act & Assert
        var error: Error?
        XCTAssertThrowsError(try Folder.at(path)) { error = $0 }
        XCTAssertEqual(error as? FishError, FishError.folderNotFound(path))
    }

    func test_create() throws {
        let path = testsFolder.subpath(.fake)

        // Act
        try Folder.create(at: path)

        // Assert
        var isFolder: ObjCBool = false
        let isExist = fileManager.fileExists(atPath: path, isDirectory: &isFolder)
        XCTAssertTrue(isExist)
        XCTAssertTrue(isFolder.boolValue)
    }

    func test_delete() throws {
        let path = testsFolder.subpath(.fake)
        try fileManager.createDirectory(atPath: path, withIntermediateDirectories: false)

        // Act
        try Folder.delete(at: path)

        // Assert
        XCTAssertFalse(fileManager.fileExists(atPath: path))
    }

    func test_size() throws {
        let folderPath = testsFolder.subpath(.fake)
        try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: false)
        let folder = try Folder.at(folderPath)
        try folder.createFile(named: .fake, contents: "new_file") // 8
        try folder.createFile(named: .fake, contents: "new_file1") // 9
        let subfolder = try folder.createFolder(named: .fake)
        try subfolder.createFile(named: .fake, contents: "new_file12") // 10
        try subfolder.createFile(named: .fake, contents: "new_file123") // 11

        // Act
        let size = try Folder.size(at: folderPath)

        // Assert
        XCTAssertEqual(size, 38)
    }
}
