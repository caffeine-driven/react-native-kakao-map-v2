//
//  CameraManager.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation
import KakaoMapsSDK

class CameraManager {
  var latitude: Double = 37.402005
  var longitude: Double = 127.108621
  var zoomLevel: Int = 15
  var rotate: Double = 0.0
  var tilt: Double = 0.0
  var onCameraChange: RCTDirectEventBlock? = nil
  let cameraAnimation = CameraAnimationOptions.init(autoElevation: true, consecutive: false, durationInMillis: 300)
  let cameraWithoutAnimation = CameraAnimationOptions.init(autoElevation: false, consecutive: false, durationInMillis: 5)
  
  func onCameraMoved(position: MapPoint, zoomLevel: Int, rotate: Double, tilt: Double, moveBy: MoveBy) {
    print(moveBy.rawValue)
    self.onCameraChange?([
      "cameraPosition": [
        "centerPosition":[
          "latitude": position.wgsCoord.latitude,
          "longitude": position.wgsCoord.longitude,
          "zoomLevel": zoomLevel
        ],
        "rotate": rotate.radiansToDegrees,
        "tilt": tilt.radiansToDegrees,
      ],
      "gestureType": self.moveByReason(moveBy: moveBy),
    ])

    
  }
  
  func updateCameraCenter(kakaoMap: KakaoMap) {
    print("shouldUpdateCenter")
    if(shouldUpdateCenter(kakaoMap: kakaoMap)) {
      print("updateCameraCenter")
      let cameraUpdate = CameraUpdate.make(
        target: MapPoint(longitude: self.longitude, latitude: self.latitude),
        zoomLevel: self.zoomLevel, mapView: kakaoMap
      )
      kakaoMap.animateCamera(cameraUpdate: cameraUpdate, options: self.cameraAnimation)
    }
  }
  
  private func shouldUpdateCenter(kakaoMap: KakaoMap) -> Bool{
    let position = kakaoMap.getPosition(CGPoint(x:kakaoMap.viewRect.width*0.5, y:kakaoMap.viewRect.height*0.5))
    return position.wgsCoord.latitude != self.latitude
    || position.wgsCoord.longitude != self.longitude
    || kakaoMap.zoomLevel != zoomLevel
  }
  
  func updateRotate(kakaoMap: KakaoMap) {
    if(shouldUpdateRotate(kakaoMap: kakaoMap)) {
      
      let cameraUpdate = CameraUpdate.make(rotation: self.rotate.degreesToRadians, tilt: kakaoMap.tiltAngle, mapView: kakaoMap)
      kakaoMap.moveCamera(cameraUpdate)
    }
    
  }
  private func shouldUpdateRotate(kakaoMap: KakaoMap) -> Bool {
    return kakaoMap.rotationAngle != self.rotate
  }
  
  func updateTilt(kakaoMap: KakaoMap) {
    if(shouldUpdateTilt(kakaoMap: kakaoMap)) {
      let cameraUpdate = CameraUpdate.make(rotation: kakaoMap.rotationAngle, tilt: self.tilt.degreesToRadians, mapView: kakaoMap)
      kakaoMap.moveCamera(cameraUpdate)
    }
    
  }
  private func shouldUpdateTilt(kakaoMap: KakaoMap) -> Bool {
    return kakaoMap.rotationAngle != self.rotate
  }
  private func moveByReason(moveBy: MoveBy) -> String {
    
    switch moveBy {
    case MoveBy.doubleTapZoomIn:
      return "OneFingerDoubleTap"
    case MoveBy.twoFingerTapZoomOut:
      return "TwoFingerSingleTap"
    case MoveBy.pan:
      return "Pan"
    case MoveBy.rotate:
      return "Rotate"
    case MoveBy.zoom:
      return "Zoom"
    case MoveBy.tilt:
      return "Tilt"
    case MoveBy.longTapAndDrag:
      return "LongTapAndDrag"
    case MoveBy.rotateZoom:
      return "RotateZoom"
    case MoveBy.oneFingerZoom:
      return "OneFingerZoom"
    default:
      return "Unknown"
    }
  }
  
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}
