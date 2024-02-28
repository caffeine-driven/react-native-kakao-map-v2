//
//  RouteLine.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation

@objc open class RouteLine: NSObject{
  var id: String;
  var segments: Array<RouteLineSegment>;
  
  @objc public init(id: String, segments: Array<RouteLineSegment>) {
    self.id = id
    self.segments = segments
  }
  
}

@objc open class RouteLineSegment: NSObject{
  var coordinates: Array<Coordinate>
  var lineWidth: NSNumber?
  var lineColor: String
  var strokeWidth: NSNumber?
  var strokeColor: String?
  @objc public init(coordinates: Array<Coordinate>, lineWidth: NSNumber? = nil, lineColor: String, strokeWidth: NSNumber? = nil, strokeColor: String? = nil) {
    self.coordinates = coordinates
    self.lineWidth = lineWidth
    self.lineColor = lineColor
    self.strokeWidth = strokeWidth
    self.strokeColor = strokeColor
  }
}
