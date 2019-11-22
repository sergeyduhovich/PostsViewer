import Foundation

struct DI {
  private static var _dependecies: Dependencies!
  private static let queue: DispatchQueue = DispatchQueue(label: "DependenciesQueue", attributes: [.concurrent])
  
  static var dependecies: Dependencies {
    get {
      queue.sync {
        return _dependecies
      }
    }
    set {
      queue.sync(flags: .barrier) {
        _dependecies = newValue
      }
    }
  }
}

protocol Dependencies {
  var userUseCase: UserUseCase { get }
  var postUseCase: PostUseCase { get }
  var authorization: AuthorizationUseCase { get }
}

class NetworkDependencies: Dependencies {
  let userUseCase: UserUseCase
  let postUseCase: PostUseCase
  let authorization: AuthorizationUseCase
  
  init() {
    let userAPI = UserUseCaseAPI()
    self.postUseCase = PostUseCaseAPI()
    self.userUseCase = userAPI
    self.authorization = AuthorizationUseCaseDefaults(userUseCase: userAPI)
  }
}

class OfflineDependencies: Dependencies {
  let userUseCase: UserUseCase
  let postUseCase: PostUseCase
  let authorization: AuthorizationUseCase
  
  init() {
    let userJSON = UserUseCaseOffline()
    self.postUseCase = PostUseCaseOffline()
    self.userUseCase = userJSON
    self.authorization = AuthorizationUseCaseDefaults(userUseCase: userJSON)
  }
}
