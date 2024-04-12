
import Foundation
import UIKit

extension UIViewController {
    private struct AssociatedKeys {
        static var loadingView: CustomLoadingView?
    }
    
    func showLoadingView(withText text: String? = nil) {
        guard let window = UIApplication.shared.windows.filter({$0.isKeyWindow}).first else {
            return
        }
        
        let loadingView = CustomLoadingView(loadingText: text)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: window.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
        
        objc_setAssociatedObject(self, &AssociatedKeys.loadingView, loadingView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func hideLoadingView() {
        if let loadingView = objc_getAssociatedObject(self, &AssociatedKeys.loadingView) as? CustomLoadingView {
            loadingView.removeFromSuperview()
        }
    }
}
