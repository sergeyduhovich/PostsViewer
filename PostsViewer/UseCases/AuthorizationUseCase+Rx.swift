import Foundation
import RxSwift
import RxCocoa

extension Reactive where Base: AuthorizationUseCase {
  
  func authorise(userId: Int) -> Observable<User> {
    let function = base.authorise(userId:completion:)
    return convertToObservable(input: userId, function: function)
  }

  var authorizationChanged: Observable<Void> {
    return Observable<Void>.create { observer -> Disposable in
      var mutableBase = self.base
      mutableBase.authorizationChanged = {
        observer.onNext(())
      }
      return Disposables.create()
    }
  }
}

