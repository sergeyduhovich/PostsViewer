import UIKit

class HomeController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let posts = UINavigationController(rootViewController: PostsViewController())
    let settings = UINavigationController(rootViewController: SettingsViewController())
    
    posts.tabBarItem.title = "Posts"
    posts.tabBarItem.image = UIImage(named: "home")
    settings.tabBarItem.title = "Me"
    settings.tabBarItem.image = UIImage(named: "settings")
    
    viewControllers = [
      posts,
      settings
    ]
  }
}
