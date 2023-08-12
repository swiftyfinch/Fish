//
//  IFolderTests.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 14.08.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Fish
import XCTest

final class IFolderTests: XCTestCase {

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

extension IFolderTests {
    func test_isEmpty() throws {
        let folder = try testsFolder.createFolder(named: .fake)

        // Act & Assert
        XCTAssertTrue(try folder.isEmpty())
    }

    func test_empty() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        try folder.createFile(named: .fake)

        // Act
        try folder.emptyFolder()

        // Assert
        XCTAssertTrue(try folder.isEmpty())
    }

    func test_folders() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let subfolders = try [
            folder.createFolder(named: .fake),
            folder.createFolder(named: .fake),
            folder.createFolder(named: .fake)
        ]

        // Act
        let resultFolders = try folder.folders()

        // Assert
        XCTAssertEqual(
            Set(resultFolders.map(\.path)),
            Set(subfolders.map(\.path))
        )
    }

    func test_pathExtension() throws {
        let folder = try testsFolder.createFolder(named: "\(String.fake).xcodeproj")

        // Act && Assert
        XCTAssertEqual(folder.pathExtension, "xcodeproj")
    }

    func test_nameExcludingExtension() throws {
        let folderName = String.fake
        let folder = try testsFolder.createFolder(named: "\(folderName).xcodeproj")

        // Act && Assert
        XCTAssertEqual(folder.nameExcludingExtension, folderName)
    }

    func test_parent() throws {
        let folder = try testsFolder.createFolder(named: "\(String.fake).xcodeproj")

        // Act && Assert
        XCTAssertNotNil(folder.parent)
        XCTAssertEqual(folder.parent?.path, testsFolder.path)
    }

    func test_relativePath() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let subfolder = try folder.createFolder(named: .fake)

        // Act
        let relativePath = subfolder.relativePath(to: testsFolder)

        // Assert
        XCTAssertEqual(relativePath, "\(folder.name)/\(subfolder.name)")
    }

    func test_size() throws {
        let folderPath = testsFolder.subpath(.fake)
        try fileManager.createDirectory(atPath: folderPath, withIntermediateDirectories: false)
        let folder = try Folder.at(folderPath)
        try folder.createFile(named: .fake, contents: "new_file") // 8
        let subfolder = try folder.createFolder(named: .fake)
        try subfolder.createFile(named: .fake, contents: "new_file1") // 9
        try subfolder.createFile(named: .fake, contents: "new_file12") // 10

        // Act && Assert
        XCTAssertEqual(try folder.size(), 27)
    }

    func test_creationDate() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let url = URL(fileURLWithPath: folder.path)
        let creationDate = try url.resourceValues(forKeys: [.creationDateKey]).creationDate

        // Act && Assert
        XCTAssertEqual(try folder.creationDate(), creationDate)
    }

    // MARK: - Move Folder

    func test_move_folder() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let destinationPath = testsFolder.subpath(.fake)

        // Act
        try folder.move(to: destinationPath, replace: false)

        // Assert
        XCTAssertTrue(Folder.isExist(at: destinationPath))
        XCTAssertFalse(Folder.isExist(at: folder.path))
    }

    func test_move_folder_failReplace() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let destinationFolder = try testsFolder.createFolder(named: .fake)
        try destinationFolder.createFolder(named: folder.name)

        // Act & Assert
        XCTAssertThrowsError(try folder.move(to: destinationFolder.path, replace: false))
    }

    func test_move_folder_replace() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let fileName = String.fake
        try folder.createFile(named: fileName)
        let destinationFolder = try testsFolder.createFolder(named: .fake)
        try destinationFolder.createFolder(named: folder.name)

        // Act
        try folder.move(to: destinationFolder.path, replace: true)

        // Assert
        XCTAssertFalse(Folder.isExist(at: folder.path))

        let movedFolderPath = destinationFolder.subpath(folder.name)
        XCTAssertTrue(Folder.isExist(at: movedFolderPath))

        let movedFileInFolderPath = destinationFolder.subpath(folder.name, fileName)
        XCTAssertTrue(File.isExist(at: movedFileInFolderPath))
    }

    // MARK: - Copy Folder

    func test_copy_folder() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let destinationPath = testsFolder.subpath(.fake)

        // Act
        try folder.copy(to: destinationPath, replace: false)

        // Assert
        XCTAssertTrue(Folder.isExist(at: destinationPath))
        XCTAssertTrue(Folder.isExist(at: folder.path))
    }

    func test_copy_folder_failReplace() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let destinationFolder = try testsFolder.createFolder(named: .fake)
        try destinationFolder.createFolder(named: folder.name)

        // Act & Assert
        XCTAssertThrowsError(try folder.copy(to: destinationFolder.path, replace: false))
    }

    func test_copy_folder_replace() throws {
        let folder = try testsFolder.createFolder(named: .fake)
        let fileName = String.fake
        try folder.createFile(named: fileName)
        let destinationFolder = try testsFolder.createFolder(named: .fake)
        try destinationFolder.createFolder(named: folder.name)

        // Act
        try folder.copy(to: destinationFolder.path, replace: true)

        // Assert
        XCTAssertTrue(Folder.isExist(at: folder.path))

        let movedFolderPath = destinationFolder.subpath(folder.name)
        XCTAssertTrue(Folder.isExist(at: movedFolderPath))

        let movedFileInFolderPath = destinationFolder.subpath(folder.name, fileName)
        XCTAssertTrue(File.isExist(at: movedFileInFolderPath))
    }
}
