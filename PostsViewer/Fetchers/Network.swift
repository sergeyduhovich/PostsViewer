import Foundation

enum NetworkError: Error {
  case noData
  case decodeFailed
}

class Network: Fetchable {
  
  private let session = URLSession(configuration: URLSessionConfiguration.default)
  
  func process<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> ()) {
    let task = session.dataTask(with: url) { (data, response, error) in
      guard let data = data else {
        DispatchQueue.main.async {
          completion(.failure(NetworkError.noData))
        }
        return
      }
      
      guard error == nil else {
        DispatchQueue.main.async {
          completion(.failure(error!))
        }
        return
      }
      
      guard let model = try? JSONDecoder().decode(T.self, from: data) else {
        DispatchQueue.main.async {
          completion(.failure(NetworkError.decodeFailed))
        }
        return
      }
      DispatchQueue.main.async {
        completion(.success(model))
      }
    }
    task.resume()
  }
}
