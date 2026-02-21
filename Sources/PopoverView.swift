import SwiftUI

struct PopoverView: View {
    @ObservedObject var viewModel: BrainBatteryViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(Int(viewModel.currentValue))%")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .center)

            Slider(value: $viewModel.currentValue, in: 0...100, step: 1) {
                Text("Brain Energy")
            } onEditingChanged: { editing in
                if !editing {
                    viewModel.update(value: viewModel.currentValue)
                }
            }

            Button("Update") {
                viewModel.update(value: viewModel.currentValue)
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .trailing)

            Divider()

            Text("Last 7 Days • Hourly Average")
                .font(.caption)
                .foregroundStyle(.secondary)

            HeatmapView(hourlyAverages: viewModel.hourlyAveragesLast7Days())
        }
        .padding(16)
        .frame(width: 320)
    }
}
