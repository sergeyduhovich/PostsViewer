import Foundation

struct Address: Codable {
  let street: String
  let suite: String
  let city: String
  let zipcode: String
  let geo: Coordinate
}
