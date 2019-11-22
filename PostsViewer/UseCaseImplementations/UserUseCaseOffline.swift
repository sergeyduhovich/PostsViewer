import Foundation

enum UserUseCaseOfflineError: Error {
  case fileNotFound
  case randomError
}

private enum UserUseCaseOfflineFiles {
  case users
  case user(Int)
  
  var url: URL? {
    switch self {
    case .users:
      return Bundle.main.url(forResource: "users", withExtension: "json")
    case .user(let identifier):
      return Bundle.main.url(forResource: "users\(identifier)", withExtension: "json")
    }
  }
}

class UserUseCaseOffline: UserUseCase {
  
  private let fetcher: Fetchable = LocalFileStorage()

  func allUsers(completion: @escaping (Result<[User], Error>) -> ()) {
    addAPILikeBehavoior(url: UserUseCaseOfflineFiles.users.url,
                        completion: completion)
  }
  
  func details(userId: Int,
               completion: @escaping (Result<User, Error>) -> ()) {
    allUsers { result in
      if case .success(let users) = result,
        let user = users.first(where: { $0.id == userId }) {
        completion(.success(user))
      } else {
        completion(.failure(UserUseCaseOfflineError.fileNotFound))
      }
    }
//    addAPILikeBehavoior(url: UserUseCaseOfflineFiles.user(userId).url,
//                        completion: completion)
  }
  
  private func addAPILikeBehavoior<T: Decodable>(
    url: URL?,
    completion: @escaping (Result<T, Error>) -> (),
    delay miliseconds: Int = Constants.LocalJSONLoader.delayMiliseconds,
    errorFrequency: Double = Constants.LocalJSONLoader.errorFrequency) {
    
    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(miliseconds)) {
      
      guard let url = url else {
        completion(.failure(UserUseCaseOfflineError.fileNotFound))
        return
      }
      
      switch Double.random(in: 0...1) {
      case 0...errorFrequency:
        completion(.failure(UserUseCaseOfflineError.randomError))
      default:
        self.fetcher.process(url: url, completion: completion)
      }
    }
  }
}
