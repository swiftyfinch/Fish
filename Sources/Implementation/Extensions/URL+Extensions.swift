//
//  URL+Extensions.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 19.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension URL {
    var name: String { lastPathComponent }
    var nameExcludingExtension: String { deletingPathExtension().lastPathComponent }
    var parent: URL { deletingLastPathComponent() }

    func relativePath(to relativePath: String) -> String {
        path.relativePath(to: relativePath)
    }

    func creationDate() throws -> Date {
        guard let creationDate = try resourceValues(forKeys: [.creationDateKey]).creationDate else {
            throw FishError.missingCreationDate(path: path)
        }
        return creationDate
    }

    func fileSize() throws -> Int {
        let keys: Set<URLResourceKey> = [.fileSizeKey]
        let resourceValues = try resourceValues(forKeys: keys)
        let size = resourceValues.fileSize
        guard let size else {
            throw FishError.missingSize(path: path)
        }
        return size
    }
}
