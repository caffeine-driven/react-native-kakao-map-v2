//
//  RouteLine.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation
import KakaoMapsSDK
import react_native_kakao_map_v2

class RouteLineManager {
  var routeStyleSets: Array<RouteStyleSet> = []
  var routeOptions: Array<RouteOptions> = []

  func loadLines(routeLines: Array<RouteLine>, kakaoMap: KakaoMap) {
    let routeManager = kakaoMap.getRouteManager()
    let _ = routeManager.addRouteLayer(layerID: "routeLayer", zOrder: 0)
    let layer = routeManager.getRouteLayer(layerID: "routeLayer")

    for routeOption in routeOptions {
      layer?.removeRoute(routeID: routeOption.routeID ?? "")
    }

    routeStyleSets.removeAll()
    routeOptions.removeAll()

    for routeLine in routeLines {
      let styleSetId = routeLine.id+"styleSet"
      let routeStyleSet = RouteStyleSet(styleID: styleSetId)

      var routeSegments = Array<RouteSegment>()

      for segment in routeLine.segments {
        let routeStyle = RouteStyle(styles: [
          PerLevelRouteStyle(
            width: segment.lineWidth?.uintValue ?? 16,
            color: hexStringToUIColor(hexColor: segment.lineColor),
            strokeWidth: segment.strokeWidth?.uintValue ?? 0,
            strokeColor: hexStringToUIColor(hexColor: segment.strokeColor ?? "#000000"), level: 0)
        ])

        routeStyleSet.addStyle(routeStyle)
        let mapPoints = self.convertCoordinates(coordinates: segment.coordinates)
        let routeSegment = RouteSegment(points: mapPoints, styleIndex: UInt(routeStyleSet.styles.count-1))
        routeSegments.append(routeSegment)
      }

      let options = RouteOptions(routeID: routeLine.id, styleID: styleSetId, zOrder: 0)
      options.segments = routeSegments
      self.routeStyleSets.append(routeStyleSet)
      self.routeOptions.append(options)

      routeManager.addRouteStyleSet(routeStyleSet)
      let route = layer?.addRoute(option: options)
      route?.show()

    }
  }

  func convertCoordinates(coordinates: Array<Coordinate>) -> [MapPoint] {
    return coordinates.map({
      (coordinate: Coordinate) -> (MapPoint) in
      MapPoint(longitude: coordinate.longitude, latitude: coordinate.latitude)
    })
  }
}
