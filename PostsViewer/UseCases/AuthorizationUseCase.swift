import Foundation
import RxSwift

protocol AuthorizationUseCase {
  static var authorizationChangedNotification: Notification.Name { get }
  var authorizationChanged: () -> Void { get set }
  
  func authorise(userId: Int,
                 completion: @escaping (Result<User, Error>) -> ())
  
  func logout()
  func isLogined() -> Bool
  func currentUserId() -> Int?
}

extension AuthorizationUseCase {
  func isLogined() -> Bool {
    return currentUserId() != nil
  }
}

extension AuthorizationUseCase {
  
  func rx_authorise(userId: Int) -> Observable<User> {
    let function = authorise(userId:completion:)
    return convertToObservable(input: userId, function: function)
  }

  var rx_authorizationChanged: Observable<Void> {
    return NotificationCenter.default
      .rx.notification(Self.authorizationChangedNotification)
      .map { _ in Void() }
  }
}
