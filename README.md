# 🧠 Brain Battery – macOS Menu Bar App

![UI of the widget![Alt text](/path/to/img.jpg)](/screen.png)

## Overview

Brain Battery is a minimal macOS menu bar application that:

* Displays a **brain icon in the macOS menu bar**
* Shows the current "brain energy" as a percentage (0–100%)
* Allows the user to update the percentage
* Logs every update with timestamp
* Displays a simple **hourly heatmap-style visualization**
* Persists data locally
* Has no backend, no sync, no external dependencies

This is a lightweight personal productivity utility.

---

## 🎯 Functional Requirements

### 1. Menu Bar Icon

* A brain icon appears in the macOS menu bar
* The icon visually reflects current battery level:

  * Empty brain = 0%
  * Full brain = 100%
  * Partial fill based on percentage
* No Dock icon
* No main window

---

### 2. Clicking the Icon Opens a Popover

The popover contains:

#### Top Section

* Current percentage (large text, e.g. `72%`)
* A slider (0–100)
* An "Update" button (or auto-save on slider release)

When the value changes:

* It is immediately saved
* It is logged with a timestamp

---

### 3. Logging System

Every time the percentage is changed:

Store:

```json
{
  "timestamp": "2026-02-21T14:32:10Z",
  "value": 72
}
```

Data should be stored locally in:

```
~/Library/Application Support/BrainBattery/log.json
```

Or use:

* `UserDefaults` (simplest option)
* OR a local JSON file (preferred for transparency)

No database required.

---

### 4. Heatmap Visualization (Simple)

Below the slider:

Display a **24-hour heatmap strip**.

Minimal implementation:

* 24 vertical bars
* One for each hour of the day
* Color intensity = average brain battery for that hour

Example logic:

* For each hour (0–23):

  * Compute average of all logged values within that hour
  * If no values → neutral gray
  * Otherwise → blue intensity proportional to value

Keep it simple:

* No calendar selection
* No date filters
* Just show today OR last 7 days averaged

Start with:

> Last 7 days averaged per hour

---

## 🛠 Technical Stack

Use:

* Swift
* SwiftUI
* AppKit (for menu bar integration)
* macOS 13+

No external dependencies.

---

## 🧩 Architecture

### App Type

* macOS App
* Menu bar only
* Use `NSStatusBar`
* Use `NSPopover`

### Components

```
BrainBatteryApp
├── StatusBarController
├── PopoverView
├── BrainBatteryViewModel
├── Logger
└── HeatmapView
```

---

## 🧠 Data Model

```swift
struct BrainEntry: Codable {
    let timestamp: Date
    let value: Int
}
```

---

## 🔄 Data Flow

1. User moves slider
2. Value is saved
3. Entry appended to local storage
4. ViewModel recalculates hourly averages
5. Heatmap redraws

---

## 🎨 Brain Icon

Use SF Symbols:

* `brain.head.profile`
* OR custom vector brain

To simulate fill level:

Option 1 (simplest):

* Overlay a mask rectangle with height proportional to value

Option 2:

* Pre-generate 10 discrete icons (0%, 10%, ..., 100%)

Simplest approach preferred.

---

## 💾 Persistence

Simplest approach:

Use a local JSON file:

```swift
func loadEntries() -> [BrainEntry]
func saveEntries(_ entries: [BrainEntry])
```

Append new entries.

Keep everything in memory while running.

---

## 🧪 MVP Scope Constraints

Keep this minimal:

* No user authentication
* No cloud sync
* No settings page
* No multiple metrics
* No AI
* No analytics
* No notifications

This is a self-tracking utility only.

---

## 📈 Future Extensions (Do NOT implement now)

* Weekly trends
* Calendar view
* Export CSV
* Correlate with sleep data
* Auto-prompt every 2 hours
* iOS companion app
* ML-based prediction of peak hours

---

## 🧠 Design Philosophy

This is not a productivity system.

It is a:

> "Self-awareness tool to understand cognitive energy rhythms."

Keep UI clean.
Keep code small.
Keep dependencies zero.

---

## 🧾 Deliverables

The final output should include:

* Working macOS menu bar app
* Heatmap view
* Local logging
* Brain fill icon
* Readable and structured code

---

## ⚠ Important Constraint

Do not over-engineer.

Prefer:

* 300 lines of simple code
  Over:
* Complex architecture.
