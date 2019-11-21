import Foundation

struct Comment: Decodable {
  let id: Int
  let postId: Int
  let name: String
  let email: String
  let body: String
}
