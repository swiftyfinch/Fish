//
//  IFileTests.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 14.08.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Fish
import XCTest

final class IFileTests: XCTestCase {

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

extension IFileTests {
    func test_append() throws {
        let content = String.fake
        let file = try testsFolder.createFile(named: .fake, contents: content)
        let appendContent = String.fake

        // Act
        try file.append(appendContent)

        // Assert
        XCTAssertEqual(try file.read(), content + appendContent)
    }

    func test_write() throws {
        let file = try testsFolder.createFile(named: .fake)
        let content = String.fake

        // Act
        try file.write(content)

        // Assert
        XCTAssertEqual(try file.read(), content)
    }

    func test_delete() throws {
        let file = try testsFolder.createFile(named: .fake)

        // Act
        try file.delete()

        // Assert
        XCTAssertFalse(File.isExist(at: file.path))
    }

    func test_readData() throws {
        let content = String.fake
        let file = try testsFolder.createFile(named: .fake, contents: content)

        // Act
        let resultData = try file.readData()

        // Assert
        XCTAssertEqual(resultData, content.data(using: .utf8))
    }

    func test_files() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let files = try [
            folder.createFile(named: .fake),
            folder.createFile(named: .fake),
            folder.createFile(named: .fake)
        ]

        // Act
        let resultFiles = try folder.files()

        // Assert
        XCTAssertEqual(
            Set(resultFiles.map(\.path)),
            Set(files.map(\.path))
        )
    }

    func test_pathExtension() throws {
        let file = try testsFolder.createFile(named: "\(String.fake).txt")

        // Act && Assert
        XCTAssertEqual(file.pathExtension, "txt")
    }

    func test_nameExcludingExtension() throws {
        let fileName = String.fake
        let file = try testsFolder.createFile(named: "\(fileName).txt")

        // Act && Assert
        XCTAssertEqual(file.nameExcludingExtension, fileName)
    }

    func test_parent() throws {
        let file = try testsFolder.createFile(named: .fake)

        // Act && Assert
        XCTAssertNotNil(file.parent)
        XCTAssertEqual(file.parent?.path, testsFolder.path)
    }

    func test_relativePath() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let file = try folder.createFile(named: .fake)

        // Act
        let relativePath = file.relativePath(to: testsFolder)

        // Assert
        XCTAssertEqual(relativePath, "\(folder.name)/\(file.name)")
    }

    func test_size() throws {
        let content = "test_content" // 12
        let file = try testsFolder.createFile(named: .fake, contents: content)

        // Act && Assert
        XCTAssertEqual(try file.size(), 12)
    }

    func test_creationDate() throws {
        let file = try testsFolder.createFile(named: .fake)
        let url = URL(fileURLWithPath: file.path)
        let creationDate = try url.resourceValues(forKeys: [.creationDateKey]).creationDate

        // Act && Assert
        XCTAssertEqual(try file.creationDate(), creationDate)
    }

    // MARK: - Move File

    func test_move_file() throws {
        let file = try testsFolder.createFile(named: .fake)
        let destinationPath = testsFolder.subpath(.fake)

        // Act
        try file.move(to: destinationPath, replace: false)

        // Assert
        XCTAssertTrue(File.isExist(at: destinationPath))
        XCTAssertFalse(File.isExist(at: file.path))
    }

    func test_move_file_failReplace() throws {
        let file = try testsFolder.createFile(named: .fake)
        let destinationFolder = try testsFolder.createFolder(named: .fake)
        try destinationFolder.createFile(named: file.name)

        // Act & Assert
        XCTAssertThrowsError(try file.move(to: destinationFolder.path, replace: false))
    }

    func test_move_file_replace() throws {
        let content = String.fake
        let file = try testsFolder.createFile(named: .fake, contents: content)
        let destinationFolder = try testsFolder.createFolder(named: .fake)
        try destinationFolder.createFile(named: file.name)

        // Act
        try file.move(to: destinationFolder.path, replace: true)

        // Assert
        XCTAssertFalse(File.isExist(at: file.path))

        let movedFile = try destinationFolder.file(named: file.name)
        XCTAssertEqual(try movedFile.read(), content)
    }

    // MARK: - Copy File

    func test_copy_file() throws {
        let file = try testsFolder.createFile(named: .fake)
        let destinationPath = testsFolder.subpath(.fake)

        // Act
        try file.copy(to: destinationPath, replace: false)

        // Assert
        XCTAssertTrue(File.isExist(at: destinationPath))
        XCTAssertTrue(File.isExist(at: file.path))
    }

    func test_copy_file_failReplace() throws {
        let file = try testsFolder.createFile(named: .fake)
        let destinationFolder = try testsFolder.createFolder(named: .fake)
        try destinationFolder.createFile(named: file.name)

        // Act & Assert
        XCTAssertThrowsError(try file.copy(to: destinationFolder.path, replace: false))
    }

    func test_copy_file_replace() throws {
        let content = String.fake
        let file = try testsFolder.createFile(named: .fake, contents: content)
        let destinationFolder = try testsFolder.createFolder(named: .fake)
        try destinationFolder.createFile(named: file.name)

        // Act
        try file.copy(to: destinationFolder.path, replace: true)

        // Assert
        XCTAssertTrue(File.isExist(at: file.path))
        XCTAssertEqual(try File.read(at: file.path), content)

        let movedFile = try destinationFolder.file(named: file.name)
        XCTAssertEqual(try movedFile.read(), content)
    }
}
