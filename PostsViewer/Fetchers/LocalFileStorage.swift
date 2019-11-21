import Foundation

enum LocalFileStorageError: Error {
  case noData
  case decodeFailed
}

class LocalFileStorage: Fetchable {
  func process<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> ()) {
    guard let data = try? Data(contentsOf: url) else {
      completion(.failure(LocalFileStorageError.noData))
      return
    }
    
    guard let model = try? JSONDecoder().decode(T.self, from: data) else {
      completion(.failure(LocalFileStorageError.decodeFailed))
      return
    }
    
    completion(.success(model))
  }
}
