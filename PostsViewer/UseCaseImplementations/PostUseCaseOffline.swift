import Foundation
import RxSwift

enum PostUseCaseOfflineError: Error {
  case fileNotFound
  case randomError
}

private enum PostUseCaseOfflineFiles {
  case posts
  case post(Int)
  case comments(Int)
  
  var url: URL? {
    switch self {
    case .posts:
      return Bundle.main.url(forResource: "posts", withExtension: "json")
    case .post(let identifier):
      return Bundle.main.url(forResource: "posts\(identifier)", withExtension: "json")
    case .comments(let identifier):
      return Bundle.main.url(forResource: "posts\(identifier)comments", withExtension: "json")
    }
  }
}

class PostUseCaseOffline: PostUseCase {
  
  private let fetcher: Fetchable = LocalFileStorage()
  
  func allPosts(completion: @escaping (Result<[Post], Error>) -> ()) {
    guard let url = PostUseCaseOfflineFiles.posts.url else {
      completion(.failure(PostUseCaseOfflineError.fileNotFound))
      return
    }
    addAPILikeBehavoior(url: url, completion: completion)
  }
  
  func details(postId: Int, completion: @escaping (Result<Post, Error>) -> ()) {
    guard let url = PostUseCaseOfflineFiles.post(postId).url else {
      completion(.failure(PostUseCaseOfflineError.fileNotFound))
      return
    }
    addAPILikeBehavoior(url: url, completion: completion)
  }
  
  func comments(postId: Int, completion: @escaping (Result<[Comment], Error>) -> ()) {
    guard let url = PostUseCaseOfflineFiles.comments(postId).url else {
      completion(.failure(PostUseCaseOfflineError.fileNotFound))
      return
    }
    addAPILikeBehavoior(url: url, completion: completion)
  }
  
  private func addAPILikeBehavoior<T: Decodable>(
    url: URL,
    completion: @escaping (Result<T, Error>) -> (),
    delay miliseconds: Int = Constants.LocalJSONLoader.delayMiliseconds,
    errorFrequency: Double = Constants.LocalJSONLoader.errorFrequency) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(miliseconds)) {
      switch Double.random(in: 0...1) {
      case 0...errorFrequency:
        completion(.failure(UserUseCaseOfflineError.randomError))
      default:
        self.fetcher.process(url: url, completion: completion)
      }
    }
  }
}

extension PostUseCaseOffline: ReactiveCompatible {}
