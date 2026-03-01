import SwiftUI

struct BrainIconView: View {
    let value: Double

    private var clampedValue: Double {
        min(max(value, 0), 100)
    }

    var body: some View {
        GeometryReader { geometry in
            let fillRatio = clampedValue / 100

            ZStack {
                Image(systemName: "brain.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.blue)
                    .mask(alignment: .bottom) {
                        Rectangle()
                            .frame(height: geometry.size.height * fillRatio)
                    }

                Image(systemName: "brain")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.primary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
