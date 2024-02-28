//
//  Utils.swift
//  react-native-kakao-map-v2
//
//  Created by caffeine.driven on 2/17/24.
//


import SwiftUI

func hexStringToUIColor(hexColor: String) -> UIColor {
  let stringScanner = Scanner(string: hexColor)

  if(hexColor.hasPrefix("#")) {
    stringScanner.scanLocation = 1
  }
  var color: UInt64 = 0
  stringScanner.scanHexInt64(&color)

  let r = CGFloat(Int(color >> 16) & 0x000000FF)
  let g = CGFloat(Int(color >> 8) & 0x000000FF)
  let b = CGFloat(Int(color) & 0x000000FF)

  return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
}
