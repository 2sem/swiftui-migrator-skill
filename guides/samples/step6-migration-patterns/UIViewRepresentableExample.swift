import SwiftUI
import UIKit

// MARK: - Using UIKit Views When Needed (UIViewRepresentable)

// An example UIKit view that we want to use in SwiftUI
class CustomActivityIndicator: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    private func setupView() {
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        activityIndicator.startAnimating()
    }
}


// The UIViewRepresentable wrapper
struct ActivityIndicatorView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> CustomActivityIndicator {
        return CustomActivityIndicator()
    }

    func updateUIView(_ uiView: CustomActivityIndicator, context: Context) {
        // Here you could update the view based on state changes in your SwiftUI view
    }
}

// Example usage in a SwiftUI view
struct RepresentableExampleView: View {
    var body: some View {
        VStack {
            Text("Below is a UIKit Activity Indicator")
            ActivityIndicatorView()
                .frame(width: 50, height: 50)
        }
    }
}
