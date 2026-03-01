import SwiftUI

struct HeatmapView: View {
    let hourlyAverages: [Double?]

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 3) {
                ForEach(0..<24, id: \.self) { hour in
                    let value = hourlyAverages[safe: hour]
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color(for: value))
                        .frame(height: 18)
                        .overlay(alignment: .bottom) {
                            if hour % 6 == 0 {
                                Text("\(hour)")
                                    .font(.system(size: 8))
                                    .foregroundStyle(.secondary)
                                    .offset(y: 12)
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity)

            HStack {
                Text("low")
                Spacer()
                Text("high")
            }
            .font(.caption2)
            .foregroundStyle(.secondary)
            .padding(.top, 8)
        }
    }

    private func color(for value: Double?) -> Color {
        guard let value else {
            return Color.gray.opacity(0.18)
        }

        let clamped = min(max(value, 0), 100)
        let opacity = 0.2 + (clamped / 100) * 0.8
        return Color.blue.opacity(opacity)
    }
}

private extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
