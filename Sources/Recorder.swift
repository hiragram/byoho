//
//  File.swift
//  byoho
//
//  Created by Yuya Hirayama on 2025/01/21.
//

import Foundation
import PathKit
import CSV

class Recorder {
    private let dateFormatter: ISO8601DateFormatter = { () in
        let f = ISO8601DateFormatter()
        f.timeZone = .current

        return f
    }()

    let dataFile: Path

    init(dataFile: Path) {
        self.dataFile = dataFile
    }

    func record(_ item: RecordItem) async throws {
        let stream = OutputStream(toFileAtPath: dataFile.string, append: true)!
        let writer = try CSVWriter(stream: stream)

        try writer.write(row: item.row(dateFormatter: dateFormatter))
        try writer.write(row: [""])
        writer.stream.close()
    }
}

private extension RecordItem {
    func row(dateFormatter: ISO8601DateFormatter) -> [String] {
        [
            dateFormatter.string(from: createdAt),
            body
        ]
    }
}
