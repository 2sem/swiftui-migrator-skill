import UIKit
import SwiftUI

// MARK: - Navigation → NavigationLink

// A dummy DetailViewController for the UIKit example
class DetailViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Detail"
    }
}

// UIKit Example of push navigation
func pushDetailViewController(navigationController: UINavigationController?) {
    let nextVC = DetailViewController()
    navigationController?.pushViewController(nextVC, animated: true)
}


// A dummy DetailScreen for the SwiftUI example
struct DetailScreen: View {
    var body: some View {
        Text("This is the detail screen")
            .navigationTitle("Detail")
    }
}

// SwiftUI
struct NavigationExample: View {
    var body: some View {
        NavigationView {
            NavigationLink("Go to Detail") {
                DetailScreen()
            }
            .navigationTitle("Main Screen")
        }
    }
}
