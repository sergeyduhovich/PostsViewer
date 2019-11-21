import Foundation

protocol PostUseCase {
  func allPosts(completion: @escaping (Result<[Post], Error>) -> ())
  func details(postId: Int,
               completion: @escaping (Result<Post, Error>) -> ())
  func comments(postId: Int,
                completion: @escaping (Result<[Comment], Error>) -> ())
}
