import Foundation
import UIKit
import SwiftUI
import KakaoMapsSDK

@objc(KakaoMapV2ViewManager)
class KakaoMapV2ViewManager: RCTViewManager {

  override func view() -> (KakaoMapV2View) {
    let view = KakaoMapV2View()
    return view
  }

  @objc override static func requiresMainQueueSetup() -> Bool {
    return false
  }
}

@objc(KakaoMapV2View)
class KakaoMapV2View : UIView, MapControllerDelegate, KakaoMapEventDelegate {
  var cameraManager = CameraManager()
  var balloonLabelManager: BalloonLabelManager?
  var lodLabelMananger: LodLabelManager?
  var currentLocationMarkerManager: CurrentLocationMarkerManager?
  var routeLineManager: RouteLineManager?
  var controller: KMController?
  var kakaoMap: KakaoMap? = nil
  lazy var mapView: KMViewContainer? = nil
  
  
  @objc var centerPosition: CenterPosition = CenterPosition(latitude: 33.56535720825195, longitude:  126.55416870117188, zoomLevel: 7) {
    didSet{
      if (kakaoMap != nil){
        self.cameraManager.latitude = centerPosition.latitude
        self.cameraManager.longitude = centerPosition.longitude
        self.cameraManager.zoomLevel = centerPosition.zoomLevel
        self.cameraManager.updateCameraCenter(kakaoMap: kakaoMap!)
      }
    }
  }
  
  @objc var rotate: NSNumber = 0.0 {
    didSet {
      self.cameraManager.rotate = rotate.doubleValue
      if (self.kakaoMap != nil){
        self.cameraManager.updateRotate(kakaoMap: self.kakaoMap!)
      }
    }
  }
  @objc var tilt: NSNumber = 0.0 {
    didSet {
      self.cameraManager.tilt = tilt.doubleValue
      if (self.kakaoMap != nil){
        self.cameraManager.updateTilt(kakaoMap: self.kakaoMap!)
      }
    }
  }
  @objc var showCurrentLocationMarker: Bool = false {
    didSet {
      let kakaoMap = controller?.getView("mapview") as? KakaoMap
      if kakaoMap != nil{
        if self.showCurrentLocationMarker {
          self.currentLocationMarkerManager?.show(kakaoMap: kakaoMap!)
        } else {
          self.currentLocationMarkerManager?.hide(kakaoMap: kakaoMap!)
        }
      }
    }
  }
  
  @objc var currentLocationMarkerOption: CurrentLocationMarkerOption? = nil {
    didSet{
      self.currentLocationMarkerManager?.loadOption(option: self.currentLocationMarkerOption)
      let kakaoMap = controller?.getView("mapview") as? KakaoMap

      if kakaoMap != nil{
        self.currentLocationMarkerManager?.updateVisibility(kakaoMap: kakaoMap!)
      }
    }
  }
  
  @objc var lodLabels: Array<LodLabel> = [] {
    didSet{
      let kakaoMap = controller?.getView("mapview") as? KakaoMap
      if kakaoMap != nil{
        self.lodLabelMananger?.loadLabels(lodLabels: self.lodLabels, kakaoMap: kakaoMap!)
        self.lodLabelMananger?.render(kakaoMap: kakaoMap!)
      }
    }
  }
  @objc var balloonLabels: Array<BalloonLabel>? = [] {
    didSet{
      let kakaoMap = controller?.getView("mapview") as? KakaoMap
      if kakaoMap != nil{
        self.balloonLabelManager?.loadLabels(balloonLabels: self.balloonLabels ?? [], kakaoMap: kakaoMap!)
        self.balloonLabelManager?.render(kakaoMap: kakaoMap!)
      }
      
    }
  }
  @objc var selectedBalloonLabel: String? = nil {
    didSet {
      self.balloonLabelManager?.onSelectLabel(labelId: self.selectedBalloonLabel)
    }
  }
  @objc var routeLines: Array<RouteLine> = [] {
    didSet{
      let kakaoMap = controller?.getView("mapview") as? KakaoMap
      if kakaoMap != nil{
        self.routeLineManager?.loadLines(routeLines: self.routeLines, kakaoMap: kakaoMap!)
      }
      
    }
  }
  
  @objc var onCameraChange: RCTDirectEventBlock? = nil {
    didSet {
      self.cameraManager.onCameraChange = self.onCameraChange
    }
  }
  @objc var onBalloonLabelSelect: RCTDirectEventBlock? = nil
  @objc var onLodLabelSelect: RCTDirectEventBlock? = nil
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.frame = frame;
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    let view: KMViewContainer = KMViewContainer(frame: frame)
    
    addSubview(view)
    controller = KMController(viewContainer: view)
    controller?.delegate = self
    controller?.initEngine()
    controller?.startEngine()
    controller?.startRendering()
    
    let kakaoMap = controller?.getView("mapview") as? KakaoMap
    
    if kakaoMap != nil {
      self.balloonLabelManager = BalloonLabelManager(
        onBalloonLabelSelected: self.balloonLabelSelectionHandler, kakaoMap: kakaoMap!
      )
      self.balloonLabelManager?.loadLabels(balloonLabels: self.balloonLabels ?? [], kakaoMap: kakaoMap!)
      self.balloonLabelManager?.render(kakaoMap: kakaoMap!)
      self.lodLabelMananger = LodLabelManager(onLodLabelSelected: self.lodLabelSelectionHandler, kakaoMap: kakaoMap!)
      self.lodLabelMananger?.loadLabels(lodLabels: self.lodLabels, kakaoMap: kakaoMap!)
      self.lodLabelMananger?.render(kakaoMap: kakaoMap!)
      self.currentLocationMarkerManager = CurrentLocationMarkerManager()
      self.currentLocationMarkerManager?.loadOption(option: self.currentLocationMarkerOption)
      self.currentLocationMarkerManager?.updateVisibility(kakaoMap: kakaoMap!)
      self.routeLineManager = RouteLineManager()
      self.routeLineManager?.loadLines(routeLines: self.routeLines, kakaoMap: kakaoMap!)
    }
    
  }
  func balloonLabelSelectionHandler(labelId: String?) {
    self.onBalloonLabelSelect?(["labelId":labelId ?? nil])
  }
  func lodLabelSelectionHandler(layerId: String?, labelId: String?) {
    self.onLodLabelSelect?([
      "layerId": layerId,
      "labelId": labelId
    ])
  }
  func addViews() {
    let defaultPosition: MapPoint = MapPoint(longitude:  self.centerPosition.longitude, latitude: self.centerPosition.latitude)
    
    let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: self.centerPosition.zoomLevel)
    
    if controller?.addView(mapviewInfo) == Result.OK {
      kakaoMap = controller?.getView("mapview") as? KakaoMap
      kakaoMap?.eventDelegate = self
    }
  }
  
  func containerDidResized(_ size: CGSize) {
    let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
    mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
  }
  
  func cameraDidStopped(kakaoMap: KakaoMapsSDK.KakaoMap, by: MoveBy){
    let pos = kakaoMap.getPosition(CGPoint(x:0.5, y:0.5))
    cameraManager.onCameraMoved(
      position: pos, zoomLevel: kakaoMap.zoomLevel, rotate: kakaoMap.rotationAngle, tilt: kakaoMap.tiltAngle, moveBy: by
    )
  }
  func terrainDidTapped(kakaoMap: KakaoMapsSDK.KakaoMap, position: KakaoMapsSDK.MapPoint) {
    self.balloonLabelSelectionHandler(labelId: nil)
  }

}
