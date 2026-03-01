# BrainBattery iPhone App

This folder contains a SwiftUI iOS app version of BrainBattery.

## What changed for iPhone

- The menu-bar brain icon is now a **large icon at the top** of the main screen.
- The rest of the controls are shown below it:
  - current percentage
  - slider
  - update button
  - day graph
  - 7-day heatmap

## Running

1. Open Xcode and create a new **iOS App** project (SwiftUI lifecycle).
2. Copy the `.swift` files from this folder into that project.
3. Run on an iPhone simulator.

The app stores data in `Application Support/BrainBattery/log.json` in the app sandbox.
