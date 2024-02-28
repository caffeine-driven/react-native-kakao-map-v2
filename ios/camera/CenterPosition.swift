//
//  CenterPosition.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/18/24.
//

import Foundation

@objc open class CenterPosition: NSObject{
  var latitude: Double
  var longitude: Double
  var zoomLevel: Int
  
  @objc public init(latitude: Double, longitude: Double, zoomLevel: Int) {
    self.latitude = latitude
    self.longitude = longitude
    self.zoomLevel = zoomLevel
  }
}
