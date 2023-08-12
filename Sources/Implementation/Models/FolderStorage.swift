//
//  FolderStorage.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 19.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct FolderStorage {
    private let folder: URL
    private let storage: IFilesManager

    init(_ folderURL: URL, storage: IFilesManager) {
        precondition(storage.isFolder(at: folderURL.path), "The path '\(folderURL.path)' isn't a folder path.")
        self.folder = folderURL
        self.storage = storage
    }
}

// MARK: - Item

extension FolderStorage: IItem {
    var path: String { folder.path }
    var pathExtension: String { folder.pathExtension }
    var name: String { folder.name }
    var nameExcludingExtension: String { folder.nameExcludingExtension }
    var parent: IFolder? { try? storage.folder(at: folder.parent.path) }

    func relativePath(to anotherFolder: IFolder) -> String { folder.relativePath(to: anotherFolder.path) }
    func creationDate() throws -> Date { try folder.creationDate() }
    func size() throws -> Int { try storage.folderSize(at: folder.path) }

    func delete() throws {
        try storage.deleteItem(at: folder.path)
    }

    func move(to folderPath: String, replace: Bool) throws {
        try storage.moveItem(at: folder, to: folderPath, replace: replace)
    }

    func copy(to folderPath: String, replace: Bool) throws {
        try storage.copyItem(at: folder, to: folderPath, replace: replace)
    }
}

// MARK: - IFolder

extension FolderStorage: IFolder {
    func subpath(_ pathComponents: String...) -> String {
        ([path] + pathComponents).joined(separator: "/")
    }

    func file(named name: String) throws -> IFile {
        try File.at(subpath(name))
    }

    func files(deep: Bool) throws -> [IFile] {
        try storage.files(at: folder.path, deep: deep)
    }

    func folders(deep: Bool) throws -> [IFolder] {
        try storage.folders(at: folder.path, deep: deep)
    }

    @discardableResult
    public func createFile(named name: String, contents text: String?) throws -> IFile {
        try storage.createFile(at: folder.appendingPathComponent(name).path, contents: text)
    }

    func createFolder(named name: String) throws -> IFolder {
        try storage.createFolder(at: folder.appendingPathComponent(name).path)
    }

    func isEmpty() throws -> Bool {
        try storage.isFolderEmpty(at: folder.path)
    }

    func emptyFolder() throws {
        try storage.emptyFolder(at: folder.path)
    }
}
