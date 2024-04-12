
import Foundation
import UIKit

class CustomLoadingView: UIView {
    private var spinner = UIActivityIndicatorView(style: .large)
    private var loadingLabel: UILabel?
    
    init(loadingText: String? = nil) {
        super.init(frame: .zero)
        setup(loadingText: loadingText)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(loadingText: String?) {
        accessibilityIdentifier = "LoadingView"
        backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        addSubview(spinner)
        
        if let text = loadingText {
            loadingLabel = UILabel()
            loadingLabel?.translatesAutoresizingMaskIntoConstraints = false
            loadingLabel?.text = text
            loadingLabel?.textColor = .white
            addSubview(loadingLabel!)
        }
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        if let label = loadingLabel {
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: spinner.bottomAnchor, constant: 20),
                label.centerXAnchor.constraint(equalTo: centerXAnchor)
            ])
        }
    }
}

