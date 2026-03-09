import SwiftUI
import UIKit

// MARK: - Delegates → Closures/Combine

// UIKit with Delegate
protocol SettingsDelegate: AnyObject {
    func didUpdateSettings()
}

class SettingsViewController: UIViewController {
    weak var delegate: SettingsDelegate?

    @objc func didTapSave() {
        delegate?.didUpdateSettings()
    }
    
    func setupButton() {
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)
        // Add button to view hierarchy
    }
}

// SwiftUI with Closure
struct SettingsScreen: View {
    var onUpdate: () -> Void

    var body: some View {
        Button("Save") {
            onUpdate()
        }
    }
}

// Usage of the SwiftUI view
struct SettingsContainerView: View {
    var body: some View {
        SettingsScreen {
            print("Settings updated")
        }
    }
}
