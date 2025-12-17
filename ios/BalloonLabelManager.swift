//
//  BalloonLabelManager.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/21/24.
//

import Foundation
import SwiftUI
import KakaoMapsSDK
import react_native_kakao_map_v2

class BalloonLabelManager {
  let layerOption: LabelLayerOptions
  let onBalloonLabelSelected: (String?) -> Void
  var balloonLabels: Dictionary<String, BalloonLabelAdapter> = [:]

  init(onBalloonLabelSelected: @escaping (String?) -> Void, kakaoMap: KakaoMap) {
    self.layerOption = LabelLayerOptions(
      layerID: "balloonLabelLayer", competitionType: .none, competitionUnit: .poi,
      orderType: .rank, zOrder: 10001)
    self.onBalloonLabelSelected = onBalloonLabelSelected
  }

  func loadLabels(balloonLabels: Array<BalloonLabel>, kakaoMap: KakaoMap) {
    self.balloonLabels = Dictionary(
      uniqueKeysWithValues: balloonLabels
        .map({
          (balloonLabel: BalloonLabel) -> (BalloonLabelAdapter) in
          BalloonLabelAdapter(balloonLabel: balloonLabel, balloonLabelTouchHandler: self.onBalloonLabelClick)
        })
        .map({
          ($0.balloonLabel.id, $0)
        }))
  }

  func render(kakaoMap: KakaoMap) {
    let _ = kakaoMap.getLabelManager().addLabelLayer(option: self.layerOption)
    let layer = kakaoMap.getLabelManager().getLabelLayer(layerID: self.layerOption.layerID)
    if (layer == nil){
      return
    }
    layer?.clearAllItems()
    balloonLabels.forEach { (key, value) in
      value.render(kakaoMap: kakaoMap, layerId: self.layerOption.layerID)
    }
  }

  func onSelectLabel(labelId: String?) {
    balloonLabels.forEach { (key, value) in
      if key == labelId {
        value.on()
      } else {
        value.off()
      }

    }
  }

  func onLabelClick(layerId: String, labelId: String) -> Bool{
    if layerId != self.layerOption.layerID {
      return false
    }
    let adapterForId = balloonLabels[labelId]
    if adapterForId == nil {
      return false
    }
    var selected: String? = nil
    if !adapterForId!.active {
      selected = labelId
    }
    self.onBalloonLabelSelected(selected)
    return true
  }

  func onBalloonLabelClick(labelId: String) {
    let _ = self.onLabelClick(layerId: self.layerOption.layerID, labelId: labelId)
  }
}


