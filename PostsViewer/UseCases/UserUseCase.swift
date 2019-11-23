import Foundation
import RxSwift

protocol UserUseCase {
  func allUsers(completion: @escaping (Result<[User], Error>) -> ())
  func details(userId: Int,
               completion: @escaping (Result<User, Error>) -> ())
}

extension Reactive where Base: UserUseCase {
  func allUsers() -> Observable<[User]> {
    let function = base.allUsers(completion:)
    return convertToObservable(function: function)
  }
  
  func details(userId: Int) -> Observable<User> {
    let function = base.details(userId:completion:)
    return convertToObservable(input: userId, function: function)
  }
}
