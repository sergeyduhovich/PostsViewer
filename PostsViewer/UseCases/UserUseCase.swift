import Foundation

protocol UserUseCase {
  func allUsers(completion: @escaping (Result<[User], Error>) -> ())
  func details(userId: Int,
               completion: @escaping (Result<User, Error>) -> ())
}
