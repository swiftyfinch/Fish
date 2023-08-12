//
//  FishError.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 19.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

/// An enumeration of all error types in Fish library.
public enum FishError: LocalizedError, Equatable {
    /// File not found at path.
    case fileNotFound(String)
    /// Folder not found at path.
    case folderNotFound(String)
    /// Failed to create files enumerator.
    case failCreateEnumerator
    /// Can't encoding text to data.
    case damagedData
    /// Missing creationDate of item at path.
    case missingCreationDate(path: String)
    /// Missing allocated size of item at path.
    case missingSize(path: String)

    public var errorDescription: String? {
        switch self {
        case .fileNotFound(let path):
            return "File not found at path '\(path)'."
        case .folderNotFound(let path):
            return "Folder not found at path '\(path)'."
        case .failCreateEnumerator:
            return "Failed to create files enumerator."
        case .damagedData:
            return "Can't encoding text to data."
        case .missingCreationDate(let path):
            return "Missing creationDate of item at path '\(path)'."
        case .missingSize(let path):
            return "Missing allocated size of item at path '\(path)'."
        }
    }
}
