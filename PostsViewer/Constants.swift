import UIKit

enum Constants {
  enum Colors {
    static let epamBlueColor = UIColor(red: 0.4609375, green: 0.80078125, blue: 0.84375, alpha: 1)
  }
  
  enum LocalJSONLoader {
    static let delayMiliseconds: Int = 700
    
    // 0 no errors, 1 - 100% errors
    static let errorFrequency: Double = 0.1
  }
  
  static let hudDismissDelay: Double = 0.5
}
