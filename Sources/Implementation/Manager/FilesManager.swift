//
//  FilesManager.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 17.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

final class FilesManager {
    let fileManager: FileManager

    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
}

extension FilesManager {
    func file(at url: URL) -> IFile {
        FileStorage(url, storage: self)
    }

    func folder(at url: URL) -> IFolder {
        FolderStorage(url, storage: self)
    }
}

extension FilesManager {
    func enumerator(for path: String,
                    deep: Bool,
                    keys: [URLResourceKey]? = nil) throws -> FileManager.DirectoryEnumerator {
        var options: FileManager.DirectoryEnumerationOptions = [.skipsHiddenFiles]
        if !deep { options.formUnion([.skipsSubdirectoryDescendants, .skipsPackageDescendants]) }
        var keys = keys ?? []
        if !keys.contains(.isRegularFileKey) { keys.append(.isRegularFileKey) }
        guard let enumerator = fileManager.enumerator(
            at: URL(fileURLWithPath: path),
            includingPropertiesForKeys: keys,
            options: options
        ) else { throw FishError.failCreateEnumerator }
        return enumerator
    }
}

extension FileManager.DirectoryEnumerator {
    func urls() -> [URL] {
        compactMap { ($0 as? URL)?.standardizedFileURL }
    }

    func filesURLs() throws -> [URL] {
        try compactMap { element in
            guard let url = (element as? URL)?.standardizedFileURL else { return nil }
            let resourceValues = try url.resourceValues(forKeys: [.isRegularFileKey])
            let isFile = (resourceValues.isRegularFile == true)
            return isFile ? url : nil
        }
    }

    func folderURLs() throws -> [URL] {
        try compactMap { element in
            guard let url = (element as? URL)?.standardizedFileURL else { return nil }
            let resourceValues = try url.resourceValues(forKeys: [.isRegularFileKey])
            let isDirectory = (resourceValues.isRegularFile != true)
            return isDirectory ? url : nil
        }
    }
}
