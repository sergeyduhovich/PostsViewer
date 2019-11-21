import Foundation

protocol Fetchable {
  func process<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> ())
}
