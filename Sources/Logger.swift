import Foundation

final class Logger {
    private let fileURL: URL
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(fileManager: FileManager = .default) {
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        decoder.dateDecodingStrategy = .iso8601

        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directory = appSupport.appendingPathComponent("BrainBattery", isDirectory: true)

        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
        fileURL = directory.appendingPathComponent("log.json")
    }

    func loadEntries() -> [BrainEntry] {
        guard let data = try? Data(contentsOf: fileURL) else {
            return []
        }
        return (try? decoder.decode([BrainEntry].self, from: data)) ?? []
    }

    func saveEntries(_ entries: [BrainEntry]) {
        guard let data = try? encoder.encode(entries) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
