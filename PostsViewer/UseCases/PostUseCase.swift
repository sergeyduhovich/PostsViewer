import Foundation
import RxSwift

protocol PostUseCase {
  func allPosts(completion: @escaping (Result<[Post], Error>) -> ())
  func details(postId: Int,
               completion: @escaping (Result<Post, Error>) -> ())
  func comments(postId: Int,
                completion: @escaping (Result<[Comment], Error>) -> ())
}

extension Reactive where Base: PostUseCase {
  func allPosts() -> Observable<[Post]> {
    let function = base.allPosts(completion:)
    return convertToObservable(function: function)
  }
  
  func details(postId: Int) -> Observable<Post> {
    let function = base.details(postId:completion:)
    return convertToObservable(input: postId, function: function)
  }
  
  func comments(postId: Int) -> Observable<[Comment]> {
    let function = base.comments(postId:completion:)
    return convertToObservable(input: postId, function: function)
  }
}
