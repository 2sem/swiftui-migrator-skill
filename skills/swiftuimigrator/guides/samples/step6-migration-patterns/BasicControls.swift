// MARK: - UILabel → Text

// UIKit
// let label = UILabel()
// label.text = "Hello"
// label.font = .systemFont(ofSize: 24, weight: .bold)
// label.textColor = .blue

// SwiftUI
// Text("Hello")
//     .font(.system(size: 24, weight: .bold))
//     .foregroundColor(.blue)

// MARK: - UIButton → Button

import UIKit
import SwiftUI

// UIKit
class ViewControllerForButton: UIViewController {
    @objc func didTapButton() {
        print("Tapped")
    }
    
    func setupButton() {
        let button = UIButton()
        button.setTitle("Tap Me", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
}

// SwiftUI
struct ButtonView: View {
    var body: some View {
        Button("Tap Me") {
            print("Tapped")
        }
    }
}
