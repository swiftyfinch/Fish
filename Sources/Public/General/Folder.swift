//
//  Folder.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 19.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

/// Returns true if the path is a directory.
public func isFolder(at path: String) -> Bool {
    Fish.sharedStorage.isFolder(at: path)
}

/// The convenient wrapper for interacting with the folder features.
public enum Folder {
    private static var storage: IFilesManager { Fish.sharedStorage }

    /// Returns the path to the program’s current directory.
    public static var current: IFolder {
        try! storage.currentFolder() // swiftlint:disable:this force_try
    }

    /// Returns the home directory for the current user.
    public static var home: IFolder {
        try! storage.homeFolder() // swiftlint:disable:this force_try
    }

    /// Returns true if the directory exists.
    /// - Parameter path: The folder path.
    public static func isExist(at path: String) -> Bool {
        storage.isFolder(at: path) && storage.isItemExist(at: path)
    }

    /// Returns the folder if it exists.
    /// - Parameter path: The folder path.
    public static func at(_ path: String) throws -> IFolder {
        try storage.folder(at: path)
    }

    /// Creates a new folder.
    /// - Parameter path: The folder path.
    @discardableResult
    public static func create(at path: String) throws -> IFolder {
        try storage.createFolder(at: path)
    }

    /// Removes the folder.
    /// - Parameter path: The folder path.
    public static func delete(at path: String) throws {
        try storage.deleteItem(at: path)
    }

    /// Obtains the folder size, in bytes.
    /// - Parameter path: The folder path.
    public static func size(at path: String) throws -> Int {
        try storage.folderSize(at: path)
    }
}
