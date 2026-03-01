import Foundation
import Combine

@MainActor
final class BrainBatteryViewModel: ObservableObject {
    @Published var draftValue: Double
    @Published private(set) var currentValue: Double
    @Published private(set) var entries: [BrainEntry]
    @Published private(set) var selectedDay: Date

    private let logger: Logger
    private let calendar = Calendar.current

    init(logger: Logger = Logger()) {
        self.logger = logger
        let initialEntries = logger.loadEntries().sorted { $0.timestamp < $1.timestamp }
        entries = initialEntries

        let lastValue = Double(initialEntries.last?.value ?? 50)
        currentValue = lastValue
        draftValue = lastValue
        selectedDay = calendar.startOfDay(for: Date())
    }

    var canShowNextDay: Bool {
        selectedDay < calendar.startOfDay(for: Date())
    }

    var selectedDayTitle: String {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateStyle = .medium

        if calendar.isDateInToday(selectedDay) {
            return "Today"
        }

        return formatter.string(from: selectedDay)
    }

    func updateDraftValue() {
        let clamped = Int(draftValue.rounded()).clamped(to: 0...100)
        let now = Date()
        currentValue = Double(clamped)
        draftValue = currentValue

        let entry = BrainEntry(timestamp: now, value: clamped)
        entries.append(entry)
        entries.sort { $0.timestamp < $1.timestamp }
        logger.saveEntries(entries)

        if calendar.isDateInToday(selectedDay) {
            selectedDay = calendar.startOfDay(for: now)
        }
    }

    func showPreviousDay() {
        guard let previous = calendar.date(byAdding: .day, value: -1, to: selectedDay) else { return }
        selectedDay = previous
    }

    func showNextDay() {
        guard canShowNextDay,
              let next = calendar.date(byAdding: .day, value: 1, to: selectedDay)
        else { return }
        selectedDay = next
    }

    func hourlyLevelsForSelectedDay() -> [Double?] {
        hourlyAverages(for: selectedDay, daysWindow: 1)
    }

    func hourlyAveragesLast7Days() -> [Double?] {
        hourlyAverages(for: Date(), daysWindow: 7)
    }

    private func hourlyAverages(for referenceDate: Date, daysWindow: Int) -> [Double?] {
        let dayStart = calendar.startOfDay(for: referenceDate)
        guard let end = calendar.date(byAdding: .day, value: 1, to: dayStart),
              let start = calendar.date(byAdding: .day, value: -(daysWindow - 1), to: dayStart)
        else {
            return Array(repeating: nil, count: 24)
        }

        let rangeEntries = entries.filter { $0.timestamp >= start && $0.timestamp < end }
        var buckets = Array(repeating: [Int](), count: 24)

        for entry in rangeEntries {
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
        Swift.min(Swift.max(self, range.lowerBound), range.upperBound)
    }
}
