import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    configureStyle()
    
    DI.dependecies = OfflineDependencies()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = RootViewController()
    window?.makeKeyAndVisible()
    
    return true
  }
  
  private func configureStyle() {
    UITabBar.appearance().barTintColor = UIColor.white
    UITabBar.appearance().tintColor = Constants.Colors.epamBlueColor
    
    SVProgressHUD.setDefaultStyle(.custom)
    SVProgressHUD.setDefaultMaskType(.black)
    SVProgressHUD.setForegroundColor(Constants.Colors.epamBlueColor)

    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().barTintColor = Constants.Colors.epamBlueColor
    UINavigationBar.appearance().titleTextAttributes = [
      .foregroundColor: UIColor.white,
      .font: UIFont.systemFont(ofSize: 16, weight: .medium)
    ]
  }
}
