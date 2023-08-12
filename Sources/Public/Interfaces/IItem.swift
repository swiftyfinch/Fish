//
//  IItem.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 19.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

/// The interface describing the basic interacting features of a file or directory.
public protocol IItem {
    /// The file path.
    var path: String { get }

    /// The path extension.
    var pathExtension: String { get }

    /// The file name.
    var name: String { get }

    /// The file name without the extension.
    var nameExcludingExtension: String { get }

    /// The parent folder of the file.
    var parent: IFolder? { get }

    // MARK: - Attributes

    /// Obtains the date the resource was created.
    func creationDate() throws -> Date

    /// Obtains the resource size, in bytes.
    func size() throws -> Int

    // MARK: - Location

    /// Returns a new path relative to the folder.
    /// - Parameter folder: The folder with the common path prefix.
    func relativePath(to folder: IFolder) -> String

    /// Removes the file or directory.
    func delete() throws

    /// Moves the file or directory to a new location.
    /// - Parameters:
    ///   - folderPath: The destination folder path.
    ///   - replace: Pass true if the file or directory needs to be replaced.
    func move(to folderPath: String, replace: Bool) throws

    /// Copies the file or directory to a new location.
    /// - Parameters:
    ///   - folderPath: The destination folder path.
    ///   - replace: Pass true if the file or directory needs to be replaced.
    func copy(to folderPath: String, replace: Bool) throws
}
