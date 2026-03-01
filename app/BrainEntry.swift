import Foundation

struct BrainEntry: Codable, Identifiable {
    let timestamp: Date
    let value: Int

    var id: Date { timestamp }
}
