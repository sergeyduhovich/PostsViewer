import Foundation
import RxSwift

typealias CompletionNoInput<T> = (@escaping (Result<T, Error>) -> ()) -> Void
typealias CompletionWithInput<I, O> = (I, @escaping (Result<O, Error>) -> ()) -> Void

func convertToObservable<T>(function: @escaping CompletionNoInput<T>) -> Observable<T> {
  return Observable<T>.create { subscriber -> Disposable in
    function { result in
      switch result {
      case .success(let val):
        subscriber.onNext(val)
        subscriber.onCompleted()
      case .failure(let err):
        subscriber.onError(err)
      }
    }
    return Disposables.create()
  }
}

func convertToObservable<I, O>(input: I, function: @escaping CompletionWithInput<I, O>) -> Observable<O> {
  Observable<O>.create { subscriber -> Disposable in
    function(input) { result in
      switch result {
      case .success(let val):
        subscriber.onNext(val)
        subscriber.onCompleted()
      case .failure(let err):
        subscriber.onError(err)
      }
    }
    return Disposables.create()
  }
}

