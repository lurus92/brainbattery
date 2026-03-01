import SwiftUI

struct PopoverView: View {
    @ObservedObject var viewModel: BrainBatteryViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            Text("\(Int(viewModel.draftValue))%")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .frame(maxWidth: .infinity, alignment: .center)

            Slider(value: $viewModel.draftValue, in: 0...100, step: 1) {
                Text("Brain Energy")
            }

            Button("Update") {
                viewModel.updateDraftValue()
            }
            .buttonStyle(.borderedProminent)
            .frame(maxWidth: .infinity, alignment: .center)

            Divider()

            VStack(spacing: 8) {
                Text("Today")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                HStack {
                    Button {
                        viewModel.showPreviousDay()
                    } label: {
                        Image(systemName: "chevron.left")
                    }

                    Spacer()

                    Text(viewModel.selectedDayTitle)
                        .font(.subheadline.weight(.medium))

                    Spacer()

                    Button {
                        viewModel.showNextDay()
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(!viewModel.canShowNextDay)
                }

                DayGraphView(hourlyLevels: viewModel.hourlyLevelsForSelectedDay())
            }

            Divider()

            Text("Last 7 Days • Hourly Average")
                .font(.caption)
                .foregroundStyle(.secondary)

            HeatmapView(hourlyAverages: viewModel.hourlyAveragesLast7Days())
        }
        .padding(16)
        .frame(width: 380)
    }
}
