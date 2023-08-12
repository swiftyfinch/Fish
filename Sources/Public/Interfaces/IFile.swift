//
//  IFile.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 19.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

/// The interface describing the interacting features of a file.
public protocol IFile: IItem {
    /// Appends the string at the end of the file.
    /// - Parameter text: The string to append.
    func append(_ text: String) throws

    /// Writes the string to the file.
    /// - Parameter text: The string to write.
    func write(_ text: String) throws

    /// Reads the string from the file.
    /// - Returns: The file content as a string.
    func read() throws -> String

    /// Reads the data from the file.
    /// - Returns: The file content as a data.
    func readData() throws -> Data
}
