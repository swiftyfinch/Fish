//
//  FilesManager+IFileManager.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 20.03.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension FilesManager: IFileManager {
    func file(at path: String) throws -> IFile {
        let fileURL = URL(fileURLWithPath: path)
        guard isItemExist(at: fileURL.path) else { throw FishError.fileNotFound(fileURL.path) }
        return file(at: fileURL)
    }

    func files(at path: String, deep: Bool) throws -> [IFile] {
        try enumerator(for: path, deep: deep).filesURLs().compactMap(file(at:))
    }

    @discardableResult
    func createFile(at path: String, contents text: String?) throws -> IFile {
        let data: Data?
        if let text {
            guard let textData = text.data(using: .utf8) else { throw FishError.damagedData }
            data = textData
        } else {
            data = nil
        }
        fileManager.createFile(atPath: path, contents: data)
        return try file(at: path)
    }

    func append(_ text: String, to file: URL) throws {
        guard let data = text.data(using: .utf8) else { throw FishError.damagedData }
        let handle = try FileHandle(forWritingTo: file)
        handle.seekToEndOfFile()
        handle.write(data)
        handle.closeFile()
    }

    func write(_ text: String, to file: URL) throws {
        guard let data = text.data(using: .utf8) else { throw FishError.damagedData }
        try data.write(to: file)
    }

    func read(file: URL) throws -> String {
        let data = try readData(file: file)
        guard let text = String(data: data, encoding: .utf8) else { throw FishError.damagedData }
        return text
    }

    func readData(file: URL) throws -> Data {
        try Data(contentsOf: file)
    }
}
