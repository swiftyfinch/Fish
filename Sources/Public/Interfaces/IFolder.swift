//
//  IFolder.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 19.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

/// The interface describing the interacting features of a folder.
public protocol IFolder: IItem {
    /// Builds a new path adding passed components to the current one.
    /// - Parameter pathComponents: The sequence of strings without slashes.
    /// - Returns: A new built path with passed components.
    func subpath(_ pathComponents: String...) -> String

    /// Returns the file with name if it exists in the current folder.
    /// - Parameter name: The file name.
    /// - Returns: A new file instance.
    func file(named name: String) throws -> IFile

    /// Finds files in the current folder.
    /// - Parameter deep: Searches recursively if it's true.
    /// - Returns: An arrays with files.
    func files(deep: Bool) throws -> [IFile]

    /// Finds folders in the current folder.
    /// - Parameter deep: Searches recursively if it's true.
    /// - Returns: An arrays with folders.
    func folders(deep: Bool) throws -> [IFolder]

    /// Creates a new file in the current folder.
    /// - Parameters:
    ///   - name: The file name.
    ///   - text: The string to write.
    /// - Returns: A new file instance.
    @discardableResult
    func createFile(
        named name: String,
        contents text: String?
    ) throws -> IFile

    /// Creates a new folder in the current one.
    /// - Parameter name: The folder name
    /// - Returns: A new folder instance.
    @discardableResult
    func createFolder(named name: String) throws -> IFolder

    /// Checks if the folder is empty.
    func isEmpty() throws -> Bool

    /// Removes everything from the current folder.
    func emptyFolder() throws
}

public extension IFolder {
    /// Finds files in the current folder.
    /// - Returns: An arrays with files.
    func files() throws -> [IFile] {
        try files(deep: false)
    }

    /// Finds folders in the current folder.
    /// - Returns: An arrays with folders.
    func folders() throws -> [IFolder] {
        try folders(deep: false)
    }

    /// Creates a new file in the current folder.
    /// - Parameter name: The file name.
    /// - Returns: A new file instance.
    @discardableResult
    func createFile(named name: String) throws -> IFile {
        try createFile(named: name, contents: nil)
    }
}
