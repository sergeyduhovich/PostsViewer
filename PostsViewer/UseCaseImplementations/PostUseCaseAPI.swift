import Foundation

enum PostEndpoint {
  private static let endpoint = "https://jsonplaceholder.typicode.com/posts"
  case posts
  case post(Int)
  case comments(Int)
  
  var url: URL {
    switch self {
    case .posts:
      return URL(string: PostEndpoint.endpoint)!
    case .post(let identifier):
      return URL(string: PostEndpoint.endpoint)!.appendingPathComponent(String(identifier))
    case .comments(let identifier):
      return URL(string: PostEndpoint.endpoint)!.appendingPathComponent(String(identifier)).appendingPathComponent("comments")
    }
  }
}

class PostUseCaseAPI: PostUseCase {
  
  private let fetcher: Fetchable = Network()
  
  func allPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
    fetcher.process(url: PostEndpoint.posts.url, completion: completion)
  }
  
  func details(postId: Int,
               completion: @escaping (Result<Post, Error>) -> ()) {
    fetcher.process(url: PostEndpoint.post(postId).url, completion: completion)
  }

  func comments(postId: Int,
                completion: @escaping (Result<[Comment], Error>) -> ()) {
    fetcher.process(url: PostEndpoint.comments(postId).url, completion: completion)
  }
}
