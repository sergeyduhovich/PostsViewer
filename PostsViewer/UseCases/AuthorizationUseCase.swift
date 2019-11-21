import Foundation

protocol AuthorizationUseCase {
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
