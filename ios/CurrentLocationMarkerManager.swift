//
//  CurrentLocationMarkerOption.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation
import KakaoMapsSDK
import CoreLocation

class CurrentLocationMarkerManager: NSObject, CLLocationManagerDelegate{
  let layerOption: LabelLayerOptions
  let markerId = "current-location-marker"
  var markerOption: CurrentLocationMarkerOption? = nil
  var enabled: Bool = false
  var kakaoMap: KakaoMap?
  //LocationManager variables
  let locationManager = CLLocationManager()
  var locationServiceAuthorized: CLAuthorizationStatus
  var latitude = 33.56535720825195
  var longitude = 126.55416870117188
  var heading = 0.0
  
  override init() {
    layerOption = LabelLayerOptions(layerID: "currentLocationMarker", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 20000)
    locationServiceAuthorized = CLAuthorizationStatus.notDetermined
    super.init()
    locationManager.delegate = self
  }
  
  func loadOption(option: CurrentLocationMarkerOption?) {
    self.markerOption = option
    // FIXME: optain options from properties(CurrentLocationMarkerOption)
    locationManager.distanceFilter = kCLDistanceFilterNone
    locationManager.headingFilter = kCLHeadingFilterNone
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }
  
  func show(kakaoMap: KakaoMap) {
    self.kakaoMap = kakaoMap
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
    let point = MapPoint(longitude: longitude, latitude: latitude)
    
    let _ = kakaoMap.getLabelManager().addLabelLayer(option: self.layerOption)
    let layer = kakaoMap.getLabelManager().getLabelLayer(layerID: self.layerOption.layerID)
    let _ = layer?.addPoi(option: poiOption, at: point)
    let poi = layer?.getPoi(poiID: self.markerId)
    poi?.show()
    poi?.moveAt(point, duration: 0)
    poi?.rotateAt(heading, duration: 0)
    
    if poi != nil {
      kakaoMap.getTrackingManager().startTrackingPoi(poi!)
    }
    
    kakaoMap.getTrackingManager().isTrackingRoll = markerOption.rotateMap?.boolValue ?? false
    startUpdateLocation()
  }
  
  func hide(kakaoMap: KakaoMap) {
    self.kakaoMap = kakaoMap
    enabled = false
    kakaoMap.getTrackingManager().stopTracking()
    let layer = kakaoMap.getLabelManager().getLabelLayer(layerID: self.layerOption.layerID)
    if layer != nil {
      layer?.clearAllItems()
    }
    stopUpdateLocation()
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
  
  //Location Manager part
  func startUpdateLocation() {
      if locationServiceAuthorized != .authorizedWhenInUse {
          locationManager.requestWhenInUseAuthorization()
      }
      else {
          locationManager.startUpdatingLocation()
          locationManager.startUpdatingHeading()
      }
  }

  func stopUpdateLocation() {
      locationManager.stopUpdatingHeading()
      locationManager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    locationServiceAuthorized = status
    if (self.kakaoMap != nil) {
      updateVisibility(kakaoMap: self.kakaoMap!)
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    longitude = locations[0].coordinate.longitude
    latitude = locations[0].coordinate.latitude
    if (self.kakaoMap != nil) {
      updateVisibility(kakaoMap: self.kakaoMap!)
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    heading = newHeading.trueHeading * Double.pi / 180.0
    if (self.kakaoMap != nil) {
      updateVisibility(kakaoMap: self.kakaoMap!)
    }
  }
}
