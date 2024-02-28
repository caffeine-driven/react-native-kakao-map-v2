//
//  BalloonLabel.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation

@objc open class BalloonLabel: NSObject{
  var id: String;
  var title: String;
  var activeIcon: String
  var inactiveIcon: String
  var latitude: NSNumber
  var longitude: NSNumber
  @objc public init(id: String, title: String, activeIcon: String, inactiveIcon: String, latitude: NSNumber, longitude: NSNumber) {
    self.id = id
    self.title = title
    self.activeIcon = activeIcon
    self.inactiveIcon = inactiveIcon
    self.latitude = latitude
    self.longitude = longitude
  }
}
