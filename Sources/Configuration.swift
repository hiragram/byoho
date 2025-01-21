//
//  File.swift
//  byoho
//
//  Created by Yuya Hirayama on 2025/01/21.
//

import Foundation
import PathKit

struct Configuration {
    var dataDirectory = Path("~/Documents/byoho").absolute()
    var dataFilePath: Path {
        dataDirectory + Path("data.csv")
    }

    static func load() async throws -> Configuration {
        let configuration = Configuration()
        return configuration
    }
}
