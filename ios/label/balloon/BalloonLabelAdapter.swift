//
//  BalloonLabelAdapter.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation
import SwiftUI
import KakaoMapsSDK

class BalloonLabelAdapter{
  let anchorPoint = CGPoint(x: 0.5, y: 1.0)
  let balloonLabelTouchHandler: (String)->Void
  let balloonLabel: BalloonLabel
  var activeLabelOption: PoiOptions?
  var inactiveLabelOption: PoiOptions?
  var label: Poi?
  var active: Bool = false
  
  init(balloonLabel: BalloonLabel, balloonLabelTouchHandler: @escaping (String)->Void) {
    self.balloonLabel = balloonLabel
    self.balloonLabelTouchHandler = balloonLabelTouchHandler
    
  }
  
  func render(kakaoMap: KakaoMap, layerId: String){
    let layer = kakaoMap.getLabelManager().getLabelLayer(layerID: layerId)
    if layer == nil {
      return
    }
    self.activeLabelOption = createActiveLabelOption(balloonLabel: balloonLabel, kakaoMap: kakaoMap, anchorPoint: anchorPoint)
    self.inactiveLabelOption = createInactiveLabelOption(balloonLabel: balloonLabel, kakaoMap: kakaoMap, anchorPoint: anchorPoint)
    self.label = layer!.addPoi(
      option: self.inactiveLabelOption!,
      at: MapPoint(
        longitude: self.balloonLabel.longitude.doubleValue,
        latitude: self.balloonLabel.latitude.doubleValue
      ), callback: {(_ poi: (Poi?)) -> Void in
        print(self.balloonLabel.id)
    })
    let _ = self.label?.addPoiTappedEventHandler(target: self, handler: BalloonLabelAdapter.labelTouchHandler)
    self.label?.show()
  }
  
  func on() {
    self.label?.changeStyle(styleID: self.activeLabelOption!.styleID)
    self.active = true
  }
  
  func off() {
    self.label?.changeStyle(styleID: self.inactiveLabelOption!.styleID)
    self.active = false
  }
  func labelTouchHandler(_ param: PoiInteractionEventParam) {
    self.balloonLabelTouchHandler(param.poiItem.itemID)
  }
}

private func createInactiveLabelOption(balloonLabel: BalloonLabel, kakaoMap: KakaoMap, anchorPoint: CGPoint) -> PoiOptions {
  let image = UIImage(named: balloonLabel.inactiveIcon)
  return createLabelOption(id: balloonLabel.id+"-inactive", balloonLabel: balloonLabel, kakaoMap: kakaoMap, anchorPoint: anchorPoint, image: image)
}


private func createActiveLabelOption(balloonLabel: BalloonLabel, kakaoMap: KakaoMap, anchorPoint: CGPoint) -> PoiOptions {
  let image = viewToImage(view: ActiveMarkerView(title: balloonLabel.title, activeImageName: balloonLabel.activeIcon))
  return createLabelOption(id: balloonLabel.id+"-active", balloonLabel: balloonLabel, kakaoMap: kakaoMap, anchorPoint: anchorPoint, image: image)
  
}

private func createLabelOption(id: String, balloonLabel: BalloonLabel, kakaoMap: KakaoMap, anchorPoint: CGPoint, image: UIImage?) -> PoiOptions {
  let manager = kakaoMap.getLabelManager()
  let iconStyle = PoiIconStyle(symbol: image, anchorPoint: anchorPoint)
  let perLevelStyle = PerLevelPoiStyle(iconStyle: iconStyle, level: 0)
  let poiStyle = PoiStyle(styleID: id, styles: [perLevelStyle])
  manager.addPoiStyle(poiStyle)
  let poiOption = PoiOptions(styleID: id, poiID: balloonLabel.id)
  poiOption.rank = 0
  poiOption.clickable = true
  return poiOption
}


struct ActiveMarkerView: View {
  var title: String
  var activeImageName: String
  
  var body: some View {
    VStack(spacing:-3.0){
      ZStack {
        Text(title).font(.system(size: 10.0)).padding(EdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0))
        }.background(
          Image(uiImage: UIImage(named: "window_body.png")!)
            .resizable(capInsets: EdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0), resizingMode:.stretch)
        )
      Image(uiImage: UIImage(named: "window_tail.png")!).padding(.bottom, 5)
      Image(uiImage: UIImage(named: activeImageName)!).padding(.bottom, 5)
    }
    
    }
}

func viewToImage(view: some View) -> UIImage? {
  let ctrl = UIHostingController(rootView: view)
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
    return image
  }
  return nil
}
