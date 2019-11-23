import Foundation
import RxSwift

extension UserUseCase {
  func rx_allUsers() -> Observable<[User]> {
    return Observable<[User]>.create { subscriber -> Disposable in
      self.allUsers { result in
        switch result {
        case .success(let users):
          subscriber.onNext(users)
          subscriber.onCompleted()
        case .failure(let error):
          subscriber.onError(error)
        }
      }
      return Disposables.create()
    }
  }
  
  func rx_details(userId: Int) -> Observable<User> {
    return Observable<User>.create { subscriber -> Disposable in
      self.details(userId: userId) { result in
        switch result {
        case .success(let user):
          subscriber.onNext(user)
          subscriber.onCompleted()
        case .failure(let error):
          subscriber.onError(error)
        }
      }
      return Disposables.create()
    }
  }
}
