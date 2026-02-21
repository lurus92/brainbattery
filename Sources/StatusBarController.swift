import AppKit
import Combine
import SwiftUI

@MainActor
final class StatusBarController {
    private let statusItem: NSStatusItem
    private let popover: NSPopover
    private let viewModel: BrainBatteryViewModel
    private var cancellables = Set<AnyCancellable>()

    init(viewModel: BrainBatteryViewModel) {
        self.viewModel = viewModel
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 320, height: 260)
        popover.contentViewController = NSHostingController(rootView: PopoverView(viewModel: viewModel))

        if let button = statusItem.button {
            button.target = self
            button.action = #selector(togglePopover)
            button.image = makeIcon(for: Int(viewModel.currentValue))
            button.toolTip = "Brain Battery: \(Int(viewModel.currentValue))%"
        }

        viewModel.$currentValue
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                self?.statusItem.button?.image = self?.makeIcon(for: Int(value))
                self?.statusItem.button?.toolTip = "Brain Battery: \(Int(value))%"
            }
            .store(in: &cancellables)
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.becomeKey()
        }
    }

    private func makeIcon(for value: Int) -> NSImage? {
        let config = NSImage.SymbolConfiguration(pointSize: 14, weight: .regular)
        guard let symbol = NSImage(systemSymbolName: "brain.head.profile", accessibilityDescription: "Brain Battery")?
            .withSymbolConfiguration(config)
        else {
            return nil
        }

        let image = NSImage(size: symbol.size)
        image.lockFocus()

        let rect = NSRect(origin: .zero, size: symbol.size)
        symbol.draw(in: rect)

        let fillHeight = rect.height * CGFloat(max(0, min(value, 100))) / 100
        let fillRect = NSRect(x: 0, y: 0, width: rect.width, height: fillHeight)
        NSColor.controlAccentColor.setFill()
        fillRect.fill(using: .sourceAtop)

        image.unlockFocus()
        image.isTemplate = false
        return image
    }
}
