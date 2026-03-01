import SwiftUI

@main
struct BrainBatteryiOSApp: App {
    @StateObject private var viewModel = BrainBatteryViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: viewModel)
        }
    }
}
