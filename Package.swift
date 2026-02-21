// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BrainBattery",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "BrainBattery", targets: ["BrainBattery"])
    ],
    targets: [
        .executableTarget(
            name: "BrainBattery",
            path: "Sources"
        )
    ]
)
