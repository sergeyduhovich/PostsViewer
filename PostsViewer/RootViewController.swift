import UIKit

class RootViewController: UIViewController {
  
  private var authorization = DI.dependencies.authorization
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor.white
    
    authorization
      .authorizationChanged = { [weak self] in
        self?.updateChildController()
    }
    
    updateChildController()
  }
  
  private func updateChildController() {
    if authorization.isLogined() {
      addChildUsing(type: HomeController.self)
    } else {
      addChildUsing(type: LoginViewController.self)
    }
  }
  
  private func addChildUsing(type: UIViewController.Type) {
    
    if children.first?.isKind(of: type) == true {
      return
    }
    
    if let child = children.first {
      child.willMove(toParent: nil)
      child.view.removeFromSuperview()
      child.removeFromParent()
    }
    
    let controller = type.init()
    addChild(controller) 
    controller.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(controller.view)
    controller.view.leadingAnchor
      .constraint(equalTo: view.leadingAnchor)
      .isActive = true
    controller.view.trailingAnchor
      .constraint(equalTo: view.trailingAnchor)
      .isActive = true
    controller.view.bottomAnchor
      .constraint(equalTo: view.bottomAnchor)
      .isActive = true
    controller.view.topAnchor
      .constraint(equalTo: view.topAnchor)
      .isActive = true
    
    controller.didMove(toParent: self)
  }
}
