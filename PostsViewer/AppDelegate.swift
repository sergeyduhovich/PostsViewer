import UIKit

enum Constants {
  enum Colors {
    static let epamBlueColor = UIColor(red: 0.4609375, green: 0.80078125, blue: 0.84375, alpha: 1)
  }
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    configureStyle()
    
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = RootViewController()
    window?.makeKeyAndVisible()
    
    return true
  }
  
  private func configureStyle() {
    UITabBar.appearance().barTintColor = UIColor.white
    UITabBar.appearance().tintColor = Constants.Colors.epamBlueColor

    UINavigationBar.appearance().tintColor = UIColor.white
    UINavigationBar.appearance().barTintColor = Constants.Colors.epamBlueColor
    UINavigationBar.appearance().titleTextAttributes = [
      .foregroundColor: UIColor.white,
      .font: UIFont.systemFont(ofSize: 16, weight: .medium)
    ]
  }
}
