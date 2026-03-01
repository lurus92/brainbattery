import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: BrainBatteryViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                BrainIconView(value: viewModel.currentValue)
                    .frame(width: 150, height: 150)
                    .padding(.top, 12)

                Text("\(Int(viewModel.draftValue))%")
                    .font(.system(size: 44, weight: .bold, design: .rounded))

                Slider(value: $viewModel.draftValue, in: 0...100, step: 1) {
                    Text("Brain Energy")
                }

                Button("Update") {
                    viewModel.updateDraftValue()
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)

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
            .padding(20)
        }
    }
}

#Preview {
    HomeView(viewModel: BrainBatteryViewModel())
}
