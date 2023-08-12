//
//  FilesManager+IFolderManager.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 20.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension FilesManager: IFolderManager {
    func currentFolder() throws -> IFolder {
        try folder(at: fileManager.currentDirectoryPath)
    }

    func homeFolder() throws -> IFolder {
        folder(at: fileManager.homeDirectoryForCurrentUser)
    }

    func isFolder(at path: String) -> Bool {
        var isFolder: ObjCBool = false
        guard fileManager.fileExists(atPath: path, isDirectory: &isFolder) else { return false }
        return isFolder.boolValue
    }

    func folder(at path: String) throws -> IFolder {
        let folderURL = URL(fileURLWithPath: path)
        guard isItemExist(at: folderURL.path) else { throw FishError.folderNotFound(folderURL.path) }
        return folder(at: folderURL)
    }

    func folders(at path: String, deep: Bool) throws -> [IFolder] {
        try enumerator(for: path, deep: deep).folderURLs().compactMap(folder(at:))
    }

    @discardableResult
    func createFolder(at path: String) throws -> IFolder {
        if !fileManager.fileExists(atPath: path) {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
        }
        return try folder(at: path)
    }

    func isFolderEmpty(at path: String) throws -> Bool {
        try enumerator(for: path, deep: false).nextObject() == nil
    }

    func emptyFolder(at path: String) throws {
        try enumerator(for: path, deep: false).urls().forEach {
            try deleteItem(at: $0.path)
        }
    }

    func folderSize(at path: String) throws -> Int {
        try enumerator(for: path, deep: true, keys: [.fileSizeKey]).filesURLs().reduce(into: 0) { size, url in
            try size += url.fileSize()
        }
    }
}
