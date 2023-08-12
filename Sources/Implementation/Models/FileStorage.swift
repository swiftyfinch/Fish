//
//  FileStorage.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 19.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct FileStorage {
    private let file: URL
    private let storage: IFilesManager

    init(_ fileURL: URL, storage: IFilesManager) {
        precondition(!storage.isFolder(at: fileURL.path), "The path '\(fileURL.path)' isn't a file path.")
        self.file = fileURL
        self.storage = storage
    }
}

// MARK: - IItem

extension FileStorage: IItem {
    var path: String { file.path }
    var pathExtension: String { file.pathExtension }
    var name: String { file.name }
    var nameExcludingExtension: String { file.nameExcludingExtension }
    var parent: IFolder? { try? storage.folder(at: file.parent.path) }

    func relativePath(to folder: IFolder) -> String { file.relativePath(to: folder.path) }
    func creationDate() throws -> Date { try file.creationDate() }
    func size() throws -> Int { try file.fileSize() }

    func delete() throws {
        try storage.deleteItem(at: file.path)
    }

    func move(to folderPath: String, replace: Bool) throws {
        try storage.moveItem(at: file, to: folderPath, replace: replace)
    }

    func copy(to folderPath: String, replace: Bool) throws {
        try storage.copyItem(at: file, to: folderPath, replace: replace)
    }
}

// MARK: - IFile

extension FileStorage: IFile {
    func append(_ text: String) throws {
        try storage.append(text, to: file)
    }

    func write(_ text: String) throws {
        try storage.write(text, to: file)
    }

    func read() throws -> String {
        try storage.read(file: file)
    }

    func readData() throws -> Data {
        try storage.readData(file: file)
    }
}
