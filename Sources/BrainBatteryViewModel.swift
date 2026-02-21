import Foundation
import Combine

@MainActor
final class BrainBatteryViewModel: ObservableObject {
    @Published var currentValue: Double
    @Published private(set) var entries: [BrainEntry]

    private let logger: Logger
    private let calendar = Calendar.current

    init(logger: Logger = Logger()) {
        self.logger = logger
        entries = logger.loadEntries().sorted { $0.timestamp < $1.timestamp }
        currentValue = Double(entries.last?.value ?? 50)
    }

    func update(value: Double) {
        let clamped = Int(value.rounded()).clamped(to: 0...100)
        currentValue = Double(clamped)

        let entry = BrainEntry(timestamp: Date(), value: clamped)
        entries.append(entry)
        logger.saveEntries(entries)
    }

    func hourlyAveragesLast7Days() -> [Double?] {
        guard let startDate = calendar.date(byAdding: .day, value: -7, to: Date()) else {
            return Array(repeating: nil, count: 24)
        }

        let recent = entries.filter { $0.timestamp >= startDate }
        var buckets = Array(repeating: [Int](), count: 24)

        for entry in recent {
            let hour = calendar.component(.hour, from: entry.timestamp)
            buckets[hour].append(entry.value)
        }

        return buckets.map { values in
            guard !values.isEmpty else { return nil }
            let sum = values.reduce(0, +)
            return Double(sum) / Double(values.count)
        }
    }
}

private extension Int {
    func clamped(to range: ClosedRange<Int>) -> Int {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
