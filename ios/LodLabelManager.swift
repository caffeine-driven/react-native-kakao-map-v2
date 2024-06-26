//
//  LodLabelManager.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/19/24.
//

import Foundation
import KakaoMapsSDK

class LodLabelManager {
  let lodLabelLayerOption: LodLabelLayerOptions
  let onLodLabelSelected: (String?, String?) -> Void
  var labelOptions: Array<PoiOptions>
  var positions: Array<MapPoint>
  
  init(onLodLabelSelected: @escaping (String?, String?) -> Void, kakaoMap: KakaoMap) {
    self.onLodLabelSelected = onLodLabelSelected
    self.lodLabelLayerOption = LodLabelLayerOptions(layerID: "lodLabelLayer", competitionType: .sameLower, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 10000, radius: 1000.0)
    self.labelOptions = []
    self.positions = []
  }
  
  func render(kakaoMap: KakaoMap) {
    let _ = kakaoMap.getLabelManager().addLodLabelLayer(option: self.lodLabelLayerOption)
    let layer = kakaoMap.getLabelManager().getLodLabelLayer(layerID: self.lodLabelLayerOption.layerID)
    if (layer == nil){
      return
    }
    layer?.clearAllItems()
    let addedLabels = layer?.addLodPois(options: self.labelOptions, at: self.positions)
    for addedLabel in addedLabels ?? [] {
      addedLabel.addPoiTappedEventHandler(target: self, handler: LodLabelManager.handleLodPoiTouch)
    }
    layer?.showAllLodPois()
  }
  func handleLodPoiTouch(_ param: PoiInteractionEventParam) {
    self.onLodLabelSelected(param.poiItem.layerID, param.poiItem.itemID)
  }
  
  func loadLabels(lodLabels: Array<LodLabel>, kakaoMap: KakaoMap) {
    labelOptions = []
    positions = []
    for lodLabel in lodLabels {
      let styles = lodLabel.styles.map(self.convertLabelStyle)
      let poiStyle = PoiStyle(styleID: lodLabel.id+"-style", styles: styles)
      kakaoMap.getLabelManager().addPoiStyle(poiStyle)
      let option = PoiOptions(styleID: lodLabel.id+"-style", poiID: lodLabel.id)
      option.clickable = lodLabel.clickable
      for idx in 0..<lodLabel.texts.count {
        option.addText(PoiText(text: lodLabel.texts[idx], styleIndex: UInt(idx)))
      }
      labelOptions.append(option)
      positions.append(MapPoint(longitude: lodLabel.longitude, latitude: lodLabel.latitude))
    }
  }
  
  func convertLabelStyle(labelStyle: LabelStyle)->PerLevelPoiStyle {
    let iconStyle = PoiIconStyle(symbol: UIImage(named: labelStyle.icon), anchorPoint: CGPoint(x: labelStyle.anchorPoint.x, y: labelStyle.anchorPoint.y))
    let textStyle = self.convertTextStyle(textStyleProps: labelStyle.textStyles)
    return PerLevelPoiStyle(iconStyle: iconStyle, textStyle: textStyle, padding: 0.0, level: Int(labelStyle.zoomLevel))
  }
  
  func convertTextStyle(textStyleProps: Array<TextStyleProp>) ->PoiTextStyle {
    let lineStyles = textStyleProps.map({
      (styleProp: TextStyleProp)->PoiTextLineStyle in
      
      var strokeThickness: UInt = 2
      if styleProp.strokeThickness != nil { strokeThickness = styleProp.strokeThickness!.uintValue }
      var strokeColor: UIColor = UIColor.white
      if styleProp.strokeColor != nil { strokeColor = hexStringToUIColor(hexColor: styleProp.strokeColor!) }
      var charSpace: Int = 0
      if styleProp.charSpace != nil { charSpace = styleProp.charSpace!.intValue }
      var lineSpace: Float = 1.0
      if styleProp.lineSpace != nil { lineSpace = styleProp.lineSpace!.floatValue }
      var aspectRatio: Float = 1.0
      if styleProp.aspectRatio != nil { aspectRatio = styleProp.aspectRatio!.floatValue }
      
      return PoiTextLineStyle(textStyle: TextStyle(
        fontSize: styleProp.fontSize.uintValue,
        fontColor: hexStringToUIColor(hexColor: styleProp.fontColor ?? "#000000"),
        strokeThickness: strokeThickness,
        strokeColor: strokeColor,
        font: "",
        charSpace: charSpace,
        lineSpace: lineSpace,
        aspectRatio: aspectRatio
      ))
    })
    return PoiTextStyle(textLineStyles: lineStyles)
  }
}
