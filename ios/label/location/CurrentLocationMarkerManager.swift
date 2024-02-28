//
//  CurrentLocationMarkerOption.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation
import KakaoMapsSDK

class CurrentLocationMarkerManager{
  let layerOption: LabelLayerOptions
  let markerId = "current-location-marker"
  var markerOption: CurrentLocationMarkerOption? = nil
  var enabled: Bool = false
  
  init() {
    self.layerOption = LabelLayerOptions(layerID: "currentLocationMarker", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 20000)
  }
  
  func loadOption(option: CurrentLocationMarkerOption?) {
    self.markerOption = option
  }
  
  func show(kakaoMap: KakaoMap) {
    enabled = true
    if self.markerOption == nil {
      return
    }
    
    let markerOption: CurrentLocationMarkerOption = self.markerOption!
    
    let manager = kakaoMap.getLabelManager()
    let iconStyle = PoiIconStyle(
      symbol: UIImage(named: markerOption.markerImage),
      anchorPoint: CGPoint(x: markerOption.offsetX?.doubleValue ?? 0.5, y: markerOption.offsetY?.doubleValue ?? 0.0)
    )
    let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
    let styleId = self.markerId+"-style"
    let poiStyle = PoiStyle(styleID: styleId, styles: [perLevelStyle])
    manager.addPoiStyle(poiStyle)
    let poiOption = PoiOptions(styleID: styleId, poiID: self.markerId)
    poiOption.rank = 0
    poiOption.clickable = true
    let point = MapPoint(longitude: markerOption.longitude, latitude: markerOption.latitude)
    
    let _ = kakaoMap.getLabelManager().addLabelLayer(option: self.layerOption)
    let layer = kakaoMap.getLabelManager().getLabelLayer(layerID: self.layerOption.layerID)
    let _ = layer?.addPoi(option: poiOption, at: point)
    let poi = layer?.getPoi(poiID: self.markerId)
    poi?.show()
    poi?.moveAt(point, duration: 0)
    poi?.rotateAt(self.convertToRadian(angle: markerOption.angle?.doubleValue ?? 0.0), duration: 0)
    
    if poi != nil {
      kakaoMap.getTrackingManager().startTrackingPoi(poi!)
    }
    
    kakaoMap.getTrackingManager().isTrackingRoll = markerOption.rotateMap?.boolValue ?? false
  }
  
  func hide(kakaoMap: KakaoMap) {
    enabled = false
    kakaoMap.getTrackingManager().stopTracking()
    let layer = kakaoMap.getLabelManager().getLabelLayer(layerID: self.layerOption.layerID)
    if layer != nil {
      layer?.clearAllItems()
    }
  }
  
  func updateVisibility(kakaoMap: KakaoMap) {
    if self.enabled {
      show(kakaoMap: kakaoMap)
    } else {
      hide(kakaoMap: kakaoMap)
    }
  }
  
  
  private func convertToRadian(angle: Double) -> Double {
    return angle * Double.pi / 180.0
  }
}
