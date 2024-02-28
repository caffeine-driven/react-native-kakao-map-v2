//
//  LodLabel.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/19/24.
//

import Foundation


@objc open class LodLabel: NSObject{
  var id: String
  var styles: Array<LabelStyle>
  var clickable: Bool
  var texts: Array<String>
  var latitude: Double
  var longitude: Double
  
  @objc public init(id: String, styles: Array<LabelStyle>, clickable: Bool, texts: Array<String>, latitude: Double, longitude: Double) {
    self.id = id
    self.styles = styles
    self.clickable = clickable
    self.texts = texts
    self.latitude = latitude;
    self.longitude = longitude;
  }
}

@objc open class LabelStyle: NSObject{
  var icon: String;
  var anchorPoint: AnchorPoints;
  var zoomLevel: Int;
  var textStyles: Array<TextStyleProp>;
  
  @objc public init(icon: String, anchorPoint: AnchorPoints, zoomLevel: Int, textStyles: Array<TextStyleProp>) {
    self.icon = icon
    self.anchorPoint = anchorPoint
    self.zoomLevel = zoomLevel
    self.textStyles = textStyles
  }
  
}

@objc open class AnchorPoints: NSObject{
  var x: Double
  var y: Double
  
  @objc public init(x: Double, y: Double) {
    self.x = x
    self.y = y
  }
}

@objc open class TextStyleProp: NSObject {
  @objc public var fontSize: NSNumber
  @objc public var fontColor: String?
  @objc public var strokeColor: String?
  @objc public var strokeThickness: NSNumber?
  @objc public var charSpace: NSNumber?
  @objc public var lineSpace: NSNumber?
  @objc public var aspectRatio: NSNumber?
  
  @objc public override init() {
    self.fontSize = 0
    self.fontColor = "#000000"
    self.strokeColor = nil
    self.strokeThickness = nil
    self.charSpace = nil
    self.lineSpace = nil
    self.aspectRatio = nil
  }
}
