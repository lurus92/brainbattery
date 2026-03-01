import SwiftUI

struct DayGraphView: View {
    let hourlyLevels: [Double?]

    private let graphHeight: CGFloat = 90

    var body: some View {
        VStack(spacing: 8) {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.12))

                    if let points = points(in: geometry.size), points.count > 1 {
                        Path { path in
                            path.move(to: points[0])
                            for point in points.dropFirst() {
                                path.addLine(to: point)
                            }
                        }
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineJoin: .round))

                        ForEach(Array(points.enumerated()), id: \.offset) { _, point in
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 4, height: 4)
                                .position(point)
                        }
                    } else {
                        Text("No data for this day")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(height: graphHeight)

            HStack {
                Text("00:00")
                Spacer()
                Text("12:00")
                Spacer()
                Text("23:00")
            }
            .font(.system(size: 10))
            .foregroundStyle(.secondary)
        }
    }

    private func points(in size: CGSize) -> [CGPoint]? {
        let values: [(hour: Int, level: Double)] = hourlyLevels.enumerated().compactMap { index, value in
            guard let value else { return nil }
            return (index, value)
        }

        guard !values.isEmpty else { return nil }

        let width = max(size.width, 1)
        let height = max(size.height, 1)

        return values.map { item in
            let x = CGFloat(item.hour) / 23.0 * width
            let y = (1.0 - CGFloat(item.level) / 100.0) * height
            return CGPoint(x: x, y: y)
        }
    }
}
