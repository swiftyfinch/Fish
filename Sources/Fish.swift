//
//  Fish.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 20.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

/// The files manager which is using in the implementations as the shared storage.
///
/// It can be changed. For example, for testing.
public var sharedStorage: IFilesManager = FilesManager(fileManager: .default)
