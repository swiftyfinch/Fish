//
//  String+Fake.swift
//  Fish
//
//  Created by Vyacheslav Khorkov on 14.08.2023.
//  Copyright © 2023 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension String {
    static var fake: String {
        UUID().uuidString
    }
}
