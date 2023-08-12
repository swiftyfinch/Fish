//
//  FilesManager+IItemManager.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 20.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension FilesManager: IItemManager {
    func isItemExist(at path: String) -> Bool {
        fileManager.fileExists(atPath: path)
    }

    func deleteItem(at path: String) throws {
        try fileManager.removeItem(atPath: path)
    }

    func moveItem(at itemURL: URL, to folderPath: String, replace: Bool) throws {
        let folder = try createFolder(at: folderPath)
        let destinationPath = folder.subpath(itemURL.name)
        if replace {
            try? deleteItem(at: destinationPath)
        }
        try fileManager.moveItem(atPath: itemURL.path, toPath: destinationPath)
    }

    func copyItem(at itemURL: URL, to folderPath: String, replace: Bool) throws {
        let folder = try createFolder(at: folderPath)
        let destinationPath = folder.subpath(itemURL.name)
        if replace {
            try? deleteItem(at: destinationPath)
        }
        try fileManager.copyItem(atPath: itemURL.path, toPath: destinationPath)
    }
}
