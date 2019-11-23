import Foundation
import RxSwift

extension PostUseCase {
  func rx_allPosts() -> Observable<[Post]> {
    return Observable<[Post]>.create { subscriber -> Disposable in
      self.allPosts { result in
        switch result {
        case .success(let posts):
          subscriber.onNext(posts)
          subscriber.onCompleted()
        case .failure(let error):
          subscriber.onError(error)
        }
      }
      return Disposables.create()
    }
  }
  
  func rx_details(postId: Int) -> Observable<Post> {
    return Observable<Post>.create { subscriber -> Disposable in
      self.details(postId: postId) { result in
        switch result {
        case .success(let post):
          subscriber.onNext(post)
          subscriber.onCompleted()
        case .failure(let error):
          subscriber.onError(error)
        }
      }
      return Disposables.create()
    }
  }
  
  func rx_comments(postId: Int) -> Observable<[Comment]> {
    return Observable<[Comment]>.create { subscriber -> Disposable in
      self.comments(postId: postId) { result in
        switch result {
        case .success(let comments):
          subscriber.onNext(comments)
          subscriber.onCompleted()
        case .failure(let error):
          subscriber.onError(error)
        }
      }
      return Disposables.create()
    }
  }
}
