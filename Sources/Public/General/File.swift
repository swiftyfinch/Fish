//
//  File.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 19.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

/// The convenient wrapper for interacting with the file features.
public enum File {
    private static var storage: IFilesManager { Fish.sharedStorage }

    /// Returns true if the file exists.
    /// - Parameter path: The file path.
    public static func isExist(at path: String) -> Bool {
        storage.isItemExist(at: path)
    }

    /// Returns the file if it exists.
    /// - Parameter name: The file path.
    public static func at(_ path: String) throws -> IFile {
        try storage.file(at: path)
    }

    /// Creates a new file.
    /// - Parameters:
    ///   - path: The file path.
    ///   - text: The string to write.
    @discardableResult
    public static func create(
        at path: String,
        contents text: String? = nil
    ) throws -> IFile {
        try storage.createFile(at: path, contents: text)
    }

    /// Removes the file.
    /// - Parameter path: The file path.
    public static func delete(at path: String) throws {
        try storage.deleteItem(at: path)
    }

    /// Reads the string from the file.
    /// - Parameter path: The file path.
    public static func read(at path: String) throws -> String {
        try storage.read(file: URL(fileURLWithPath: path))
    }
}
