import Foundation
import CoreLocation.CLLocation

struct Coordinate: Codable {
  let lat: String
  let lng: String
}

extension Coordinate {
  var location: CLLocationCoordinate2D? {
    guard let lat = CLLocationDegrees(lat), let lng = CLLocationDegrees(lng) else { return nil }
    return CLLocationCoordinate2D(latitude: lat, longitude: lng)
  }
}
