//
//  Coordinate.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation

@objc open class Coordinate: NSObject {
  var latitude: Double;
  var longitude: Double;
  @objc public init(latitude: Double, longitude: Double) {
    self.latitude = latitude
    self.longitude = longitude
  }
}
