//
//  CurrentLocationMarkerOption.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation
@objc open class CurrentLocationMarkerOption: NSObject {
  var latitude: Double
  var longitude: Double
  var markerImage: String
  @objc public var angle: NSNumber?
  @objc public var rotateMap: NSNumber?
  @objc public var offsetX: NSNumber?
  @objc public var offsetY: NSNumber?
  
  @objc public init(latitude: Double, longitude: Double, markerImage: String) {
    self.latitude = latitude
    self.longitude = longitude
    self.markerImage = markerImage
    self.angle = nil
    self.rotateMap = nil
    self.offsetX = nil
    self.offsetY = nil
  }
}
