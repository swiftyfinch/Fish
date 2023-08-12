//
//  String+RelativePath.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 21.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

public extension String {
    /// Removes the prefix if it equals to the path.
    ///
    /// The path can contain `/` at the end.
    ///
    /// - Parameter path: The path with the common prefix to the string.
    /// - Returns: A new string without the path prefix or the same string.
    func relativePath(to path: String) -> String {
        let path = path.hasSuffix("/") ? path : "\(path)/"
        if hasPrefix(path) {
            return String(dropFirst(path.count))
        }
        return self
    }
}
