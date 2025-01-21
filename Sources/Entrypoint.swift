//
//  File.swift
//  byoho
//
//  Created by Yuya Hirayama on 2025/01/21.
//

import Foundation
import ArgumentParser
import PathKit
import Rainbow

@main
struct Bh: AsyncParsableCommand {
    @Argument var body: String

    mutating func run() async throws {
        let configuration = try await Configuration.load()

        try await prepareData(configuration: configuration)

        let recordItem = RecordItem(
            createdAt: Date(),
            body: body
        )
        try await createRecord(item: recordItem, configuration: configuration)

        do {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            print("[\(dateFormatter.string(from: recordItem.createdAt))]".yellow.dim, ": \(recordItem.body)")
        }
    }

    private func createRecord(item: RecordItem, configuration: Configuration) async throws {
        let recorder = Recorder(dataFile: configuration.dataFilePath)
        try await recorder.record(item)
    }

    private func prepareData(configuration: Configuration) async throws {
        let dataDirectory = configuration.dataDirectory.absolute()
        if !dataDirectory.exists {
            printNotice("Creating a data directory at \(dataDirectory)")
            try dataDirectory.mkpath()
        }
        let dataPath = configuration.dataFilePath
        if !dataPath.exists {
            printNotice("Creating a data file at \(dataPath)")
            try dataPath.write(.init())
        }
    }
}
