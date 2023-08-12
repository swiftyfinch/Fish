//
//  IFilesManager.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 19.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

/// Composition of all files manager protocols.
public typealias IFilesManager = IItemManager & IFileManager & IFolderManager

// MARK: - IItemManager

/// The interface describing the basic file or directory manager.
public protocol IItemManager {
    /// Returns true if the file or directory exists at the path.
    /// - Parameter path: The file or directory path.
    func isItemExist(at path: String) -> Bool

    /// Removes the file or directory at the path.
    /// - Parameter path: The file or directory path.
    func deleteItem(at path: String) throws

    /// Moves the file or directory to a new location.
    /// - Parameters:
    ///   - itemURL: The file or directory url.
    ///   - folderPath: The destination folder path.
    ///   - replace: Pass true if the file or directory needs to be replaced.
    func moveItem(
        at itemURL: URL,
        to folderPath: String,
        replace: Bool
    ) throws

    /// Copies the file or directory to a new location.
    /// - Parameters:
    ///   - itemURL: The file or directory url.
    ///   - folderPath: The destination folder path.
    ///   - replace: Pass true if the file or directory needs to be replaced.
    func copyItem(
        at itemURL: URL,
        to folderPath: String,
        replace: Bool
    ) throws
}

// MARK: - IFileManager

/// The interface describing the file manager.
public protocol IFileManager {
    /// Returns the file at the path if it exists.
    /// - Parameter path: The file path.
    func file(at path: String) throws -> IFile

    /// Finds files at the path.
    /// - Parameters:
    ///   - path: The folder path.
    ///   - deep: Searches recursively if it's true.
    func files(
        at path: String,
        deep: Bool
    ) throws -> [IFile]

    /// Creates a new file at the path.
    /// - Parameters:
    ///   - path: The file path.
    ///   - text: The string to write.
    @discardableResult
    func createFile(
        at path: String,
        contents text: String?
    ) throws -> IFile

    // MARK: - Read/Write

    /// Appends the string at the end of the file at the url.
    /// - Parameters:
    ///   - text: The string to append.
    ///   - file: The file url.
    func append(
        _ text: String,
        to file: URL
    ) throws

    /// Writes the string to the file at the url.
    /// - Parameters:
    ///   - text: The string to write.
    ///   - file: The file url.
    func write(
        _ text: String,
        to file: URL
    ) throws

    /// Reads the string from the file at the url.
    /// - Parameter file: The file url.
    func read(file: URL) throws -> String

    /// Reads the data from the file at the url.
    /// - Parameter file: The file url.
    func readData(file: URL) throws -> Data
}

// MARK: - IFolderManager

/// The interface describing the directory manager.
public protocol IFolderManager {
    /// Returns the path to the program’s current directory.
    func currentFolder() throws -> IFolder

    /// Returns the home directory for the current user.
    func homeFolder() throws -> IFolder

    /// Returns true if the path is a directory.
    func isFolder(at path: String) -> Bool

    /// Returns the folder at the path if it exists.
    /// - Parameter path: The folder path.
    func folder(at path: String) throws -> IFolder

    /// Finds folders at the path.
    /// - Parameters:
    ///   - path: The folder path.
    ///   - deep: Searches recursively if it's true.
    func folders(
        at path: String,
        deep: Bool
    ) throws -> [IFolder]

    /// Creates a new folder at the path.
    /// - Parameter path: The folder path.
    @discardableResult
    func createFolder(at path: String) throws -> IFolder

    /// Checks if the folder is empty.
    /// - Parameter path: The folder path.
    func isFolderEmpty(at path: String) throws -> Bool

    /// Removes everything from the folder.
    /// - Parameter path: The folder path.
    func emptyFolder(at path: String) throws

    /// Obtains the folder size, in bytes.
    /// - Parameter path: The folder path.
    func folderSize(at path: String) throws -> Int
}
