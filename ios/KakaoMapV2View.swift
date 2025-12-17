//
//  KakaoMapView.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/17/24.
//


import SwiftUI
import KakaoMapsSDK


class KakaoMapCoordinator: NSObject, MapControllerDelegate, KakaoMapEventDelegate {
  var controller: KMController?
  var kakaoMap: KakaoMap? = nil
  var cameraManager: CameraManager? = nil
  var infoWindow: InfoWindow?
  
  func createController(_ view: KMViewContainer) {
    controller = KMController(viewContainer: view)
    controller?.delegate = self
  }
  
  func addViews() {
    let defaultPosition: MapPoint = MapPoint(longitude:  126.55416870117188, latitude: 33.56535720825195)
    
    let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 9)
    
    controller?.addView(mapviewInfo)
  }
  
  func addViewSucceeded(_ viewName: String, viewInfoName: String) {
    kakaoMap = controller?.getView("mapview") as? KakaoMap
    kakaoMap?.eventDelegate = self
  }
  
  func containerDidResized(_ size: CGSize) {
    let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
    mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
  }
  
  func cameraDidStopped(kakaoMap: KakaoMapsSDK.KakaoMap, by: MoveBy){
    let pos = kakaoMap.getPosition(CGPoint(x:0.5, y:0.5))
    cameraManager?.onCameraMoved(
      position: pos, zoomLevel: kakaoMap.zoomLevel, rotate: kakaoMap.rotationAngle, tilt: kakaoMap.tiltAngle, moveBy: by
    )
    if(infoWindow == nil) {
      createInfoWindow()
    } else {
//      let a = infoWindow?.tail!!
//      a
    }
    
  }
  
  
  func createInfoWindow() {
    let ctrl = UIHostingController(rootView: MarkerView())
    let view = ctrl.view
    view?.backgroundColor = .clear
    
    if let rootVC = UIApplication.shared.windows.first?.rootViewController {
      rootVC.view.insertSubview(ctrl.view, at: 0)
      let targetSize = ctrl.view.intrinsicContentSize
      view?.bounds = CGRect(origin: .zero, size: targetSize)
      let renderer = UIGraphicsImageRenderer(size: targetSize)
      let image =  renderer.image { _ in
          view?.drawHierarchy(in: ctrl.view.bounds, afterScreenUpdates: true)
      }
      ctrl.view.removeFromSuperview()
      let guiImage = GuiImage("markerImage")
      guiImage.image = image
      
      let infoWindow = InfoWindow("infoWindow");
      infoWindow.body = guiImage
      
      infoWindow.position = MapPoint(longitude: 126.55416870117188, latitude: 33.56535720825195)
      let infoWindowLayer = kakaoMap?.getGuiManager().infoWindowLayer
      infoWindowLayer?.addInfoWindow(infoWindow)
      infoWindow.show()
    }

    
    
//      let infoWindow = InfoWindow("infoWindow");
//
//      // bodyImage
//      let bodyImage = GuiImage("bgImage")
//      bodyImage.image = UIImage(named: "window.png")
//      bodyImage.imageStretch = GuiEdgeInsets(top: 10, left: 10, bottom: 25, right: 10)
//
//      // tailImage
//      let tailImage = GuiImage("tailImage")
//      tailImage.image = UIImage(named: "window_tail.png")
//      
//      //bodyImage의 child로 들어갈 layout.
//      let layout: GuiLayout = GuiLayout("layout")
//      layout.arrangement = .horizontal    //가로배치
//
//      let text = GuiText("text")
//      let style = KakaoMapsSDK.TextStyle(fontSize: 20)
//      text.addText(text: "안녕하세요~", style: style)
//      //Text의 정렬. Layout의 크기는 child component들의 크기를 모두 합친 크기가 되는데, Layout상의 배치에 따라 공간의 여분이 있는 component는 align을 지정할 수 있다.
//      text.align = GuiAlignment(vAlign: .middle, hAlign: .left)   // 좌중단 정렬.
//      
//      bodyImage.child = layout
//      infoWindow.body = bodyImage
//      infoWindow.tail = tailImage
//      infoWindow.bodyOffset.y = -10
//
//      layout.addChild(text)
//      
//      infoWindow.position = MapPoint(longitude: 126.55416870117188, latitude: 33.56535720825195)
//
//      let infoWindowLayer = kakaoMap?.getGuiManager().infoWindowLayer
//      infoWindowLayer?.addInfoWindow(infoWindow)
//      infoWindow.show()
  }
  
//    let pos = kakaoMap.getPosition(CGPoint(x:0.5, y:0.5))
//    
//    
//    self.onCameraChange?([
//      "cameraPosition": [
//        "centerPosition":[
//          "latitude": pos.wgsCoord.latitude,
//          "longitude": pos.wgsCoord.longitude,
//          "zoomLevel": kakaoMap.zoomLevel
//        ],
//        "rotate": kakaoMap.rotationAngle,
//        "tilt": kakaoMap.tiltAngle,
//      ],
//      "gestureType": "Unknown",
//    ])
//    self.onLodLabelSelect?([
//      "layerId":"test-layer-id",
//      "labelId":"test-label-id"
//    ])
//    self.onBalloonLabelSelect?(["labelId":"test-label-id"])
//  }
}

struct MarkerView: View {
  var body: some View {
    VStack(spacing:-3.0){
      ZStack {
          Text("asdf").padding(EdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0))
        }.background(
          Image(uiImage: UIImage(named: "window_body.png")!)
            .resizable(capInsets: EdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0), resizingMode:.stretch)
        )
      Image(uiImage: UIImage(named: "window_tail.png")!).padding(.bottom, 5)
      Image(uiImage: UIImage(named: "green_marker.png")!).padding(.bottom, 5)
    }
    
    }
}
