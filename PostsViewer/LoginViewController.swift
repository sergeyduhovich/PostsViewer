import UIKit 

class LoginViewController: UIViewController {
  
  private let authorization: AuthorizationUseCase = AuthorizationUseCaseDefaults()
  
  @IBOutlet private var identifierField: UITextField!
  @IBOutlet private var passwordField: UITextField!
  @IBOutlet private var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    identifierField.placeholder = "login id in range 1...10"
    identifierField.textColor = Constants.Colors.epamBlueColor
    identifierField.autocorrectionType = .no
    
    passwordField.placeholder = "password"
    passwordField.textColor = Constants.Colors.epamBlueColor
    passwordField.isSecureTextEntry = true
    identifierField.autocorrectionType = .no
    
    loginButton.setTitle("login", for: .normal)
    loginButton.tintColor = Constants.Colors.epamBlueColor
  }
  
  @IBAction func loginAction() {
    guard let userId = identifierField.text.flatMap(Int.init) else {
      showAlert(message: "Wrong identifier format")
      return
    }
    
    authorization.authorise(userId: userId) { [weak self] result in
      switch result {
      case .success(let user):
        print("logined user \(user.username)")
      case .failure(let error):
        self?.showAlert(message: error.localizedDescription)
      }
    }
  }
}
