import UIKit
import SwiftUI
import Combine

class ViewController: UIViewController {
    let childVC = UIHostingController(rootView: ProgressBar(vm: ProgressBarViewModel()))
    var cancellable: AnyCancellable?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        addChild(childVC)
        view.addSubview(childVC.view)

        let button = UIButton(configuration: .plain())
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(start), for: .touchDown)

        let stackView = UIStackView(arrangedSubviews: [childVC.view, button])
        stackView.axis = .vertical
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        childVC.view.translatesAutoresizingMaskIntoConstraints = false

        cancellable = childVC.rootView.hideSub.sink {
            self.childVC.view.isHidden = true
        }
    }

    @objc
    func start() {
        print("Started!")
        childVC.rootView.start()
    }
}
