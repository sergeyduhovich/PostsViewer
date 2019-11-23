import UIKit
import SVProgressHUD

class SettingsViewController: UIViewController {
  
  private let authorization = DI.dependencies.authorization
  private let userCase = DI.dependencies.userUseCase
  
  @IBOutlet private var name: UILabel!
  @IBOutlet private var username: UILabel!
  @IBOutlet private var email: UILabel!
  @IBOutlet private var street: UILabel!
  @IBOutlet private var suite: UILabel!
  @IBOutlet private var city: UILabel!
  @IBOutlet private var zipcode: UILabel!
  @IBOutlet private var phone: UILabel!
  @IBOutlet private var website: UILabel!
  @IBOutlet private var nameC: UILabel!
  @IBOutlet private var catchPhraseC: UILabel!
  @IBOutlet private var bsC: UILabel!
  
  @IBOutlet private var logoutButton: UIButton!
  
  var user: User? {
    didSet {
      guard isViewLoaded == true else { return }
      updateView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    logoutButton.setTitle("logout", for: .normal)
    logoutButton.tintColor = Constants.Colors.epamBlueColor
    updateView()
    
    if user == nil {
      guard let userId = authorization.currentUserId() else {
        return
      }
      SVProgressHUD.show()
      userCase.details(userId: userId) { [weak self] result in
        SVProgressHUD.dismiss()
        switch result {
        case .success(let user):
          self?.user = user
        case .failure(_):
          SVProgressHUD.showError(withStatus: "User loading failed")
          SVProgressHUD.dismiss(withDelay: Constants.hudDismissDelay)
        }
      }
    }
  }
  
  @IBAction func logoutAction() {
    authorization.logout()
  }
  
  private func updateView() {
    name.text = user?.name
    username.text = user?.username
    email.text = user?.email
    street.text = user?.address.street
    suite.text = user?.address.suite
    city.text = user?.address.city
    zipcode.text = user?.address.zipcode
    phone.text = user?.phone
    website.text = user?.website
    nameC.text = user?.company.name
    catchPhraseC.text = user?.company.catchPhrase
    bsC.text = user?.company.bs
    
    if authorization.currentUserId() == user?.id {
      logoutButton.isHidden = false
      title = "me"
    } else {
      logoutButton.isHidden = true
      title = user?.name
    }
  }
  
  deinit {
    print("\(#file) \(#function)")
  }
}
