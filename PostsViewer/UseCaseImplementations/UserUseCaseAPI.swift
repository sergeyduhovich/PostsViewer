import Foundation

enum UserEndpoint {
  private static let endpoint = "https://jsonplaceholder.typicode.com/users"
  case users
  case user(Int)
  
  var url: URL {
    switch self {
    case .users:
      return URL(string: UserEndpoint.endpoint)!
    case .user(let identifier):
      return URL(string: UserEndpoint.endpoint)!.appendingPathComponent(String(identifier))
    }
  }
}

class UserUseCaseAPI: UserUseCase {
  
  private let fetcher: Fetchable = Network()
  
  func allUsers(completion: @escaping (Result<[User], Error>) -> ()) {
    fetcher.process(url: UserEndpoint.users.url, completion: completion)
  }
  
  func details(userId: Int, completion: @escaping (Result<User, Error>) -> ()) {
    fetcher.process(url: UserEndpoint.user(userId).url, completion: completion)
  }
}
