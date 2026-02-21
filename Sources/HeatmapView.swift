import SwiftUI

struct HeatmapView: View {
    let hourlyAverages: [Double?]

    var body: some View {
        HStack(alignment: .bottom, spacing: 4) {
            ForEach(Array(hourlyAverages.enumerated()), id: \.offset) { index, average in
                VStack(spacing: 2) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(color(for: average))
                        .frame(width: 10, height: 44)
                        .overlay(alignment: .bottom) {
                            if let average {
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.blue)
                                    .frame(height: max(4, CGFloat(average / 100) * 44))
                                    .opacity(0.9)
                            }
                        }

                    if index % 6 == 0 {
                        Text("\(index)")
                            .font(.system(size: 8))
                            .foregroundStyle(.secondary)
                    } else {
                        Text(" ")
                            .font(.system(size: 8))
                    }
                }
            }
        }
        .padding(.top, 8)
    }

    private func color(for average: Double?) -> Color {
        guard let average else { return Color.gray.opacity(0.25) }
        return Color.blue.opacity(0.2 + (average / 100) * 0.7)
    }
}
