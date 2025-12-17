//
//  BalloonLabelAdapter.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation
import SwiftUI
import KakaoMapsSDK
import react_native_kakao_map_v2

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
  poiOption.transformType = .absoluteRotation
  poiOption.clickable = true
  return poiOption
}


struct ActiveMarkerView: View {
  var title: String
  var activeImageName: String
  let bundle = UIImage.named("window_body.png")!

  var body: some View {
    VStack(spacing:-3.0){
      ZStack {
        Text(title).font(.system(size: 10.0)).padding(EdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0))
        }.background(
          Image(uiImage: UIImage.named("window_body.png")!)
            .resizable(capInsets: EdgeInsets(top: 5.0, leading: 5.0, bottom: 5.0, trailing: 5.0), resizingMode:.stretch)
        )
      Image(uiImage: UIImage.named("window_tail.png")!).padding(.bottom, 5)
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
    let rawImage =  renderer.image { _ in
      view?.drawHierarchy(in: ctrl.view.bounds, afterScreenUpdates: true)
    }
    guard let finalImage = rawImage.normalizedImage() else {
        print("이미지 정규화 실패")
        return nil
    }
    return finalImage
  }
  return nil
}

extension UIImage {
    static func named(_ name: String) -> UIImage? {
        // 1. 현재 클래스가 속한 번들을 찾음
        let bundle = Bundle(for: BalloonLabelAdapter.self)
        
        // 2. 만약 resource_bundles를 썼다면 그 하위의 .bundle 파일을 다시 찾아야 함
        if let resourceBundleURL = bundle.url(forResource: "ReactNativeKakaoMapV2", withExtension: "bundle"),
           let resourceBundle = Bundle(url: resourceBundleURL) {
            return UIImage(named: name, in: resourceBundle, compatibleWith: nil)
        }
        
        // 3. resource_bundles를 안 쓰고 s.resources를 썼을 경우 대비
        return UIImage(named: name, in: bundle, compatibleWith: nil)
    }
    func normalizedImage() -> UIImage? {
          // 이미지가 없으면 nil 반환
          guard let cgImage = self.cgImage else { return nil }
          
          // 표준 RGBA 포맷으로 비트맵 컨텍스트 생성
          let colorSpace = CGColorSpaceCreateDeviceRGB()
          let width = cgImage.width
          let height = cgImage.height
          let bytesPerPixel = 4
          let bytesPerRow = bytesPerPixel * width
          let bitsPerComponent = 8
          
          // kCGImageAlphaPremultipliedLast를 사용하여 표준 RGBA 보장
          guard let context = CGContext(data: nil,
                                        width: width,
                                        height: height,
                                        bitsPerComponent: bitsPerComponent,
                                        bytesPerRow: bytesPerRow,
                                        space: colorSpace,
                                        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
              return nil
          }
          
          // 생성된 컨텍스트에 현재 이미지를 그림
          context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
          
          // 다시 UIImage로 변환
          guard let newCgImage = context.makeImage() else { return nil }
          return UIImage(cgImage: newCgImage)
      }
}
