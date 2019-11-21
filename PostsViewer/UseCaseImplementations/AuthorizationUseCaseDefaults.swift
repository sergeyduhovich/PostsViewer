import Foundation

class AuthorizationUseCaseDefaults: AuthorizationUseCase {
  
  static let authorizationChangedNotification = NSNotification.Name("authorizationChangedNotification")
  
  init() {
    NotificationCenter.default.addObserver(forName: AuthorizationUseCaseDefaults.authorizationChangedNotification, object: nil, queue: nil) { [weak self] _ in
      self?.authorizationChanged()
    }
  }
  
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  private let userUseCase: UserUseCase = UserUseCaseAPI()
  private let userIdKey = "currentUserId"
  private let queue: DispatchQueue = DispatchQueue(label: "AuthorizationQueue", attributes: [.concurrent])
  
  private var userId: Int? {
    get {
      queue.sync {
        return UserDefaults.standard.string(forKey: self.userIdKey).flatMap(Int.init)
      }
    }
    set {
      queue.sync(flags: .barrier) {
        if let userId = newValue {
          UserDefaults.standard.set(String(describing: userId), forKey: self.userIdKey)
          UserDefaults.standard.synchronize()
        } else {
          UserDefaults.standard.removeObject(forKey: self.userIdKey)
          UserDefaults.standard.synchronize()
        }
      }
    }
  }
  
  var authorizationChanged: () -> Void = {}
  
  func authorise(userId: Int,
                 completion: @escaping (Result<User, Error>) -> ()) {
    userUseCase.details(userId: userId) { [weak self] result in
      switch result {
      case .success(let user):
        self?.userId = userId
        NotificationCenter.default.post(name: AuthorizationUseCaseDefaults.authorizationChangedNotification, object: nil)
        completion(.success(user))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
  
  func logout() {
    userId = nil
    NotificationCenter.default.post(name: AuthorizationUseCaseDefaults.authorizationChangedNotification, object: nil)
  }
  
  func currentUserId() -> Int? {
    return userId
  }
}

