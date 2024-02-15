package net.devcaffeine.kakaomapv2.label.location

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.views.imagehelper.ResourceDrawableIdHelper
import com.kakao.vectormap.KakaoMap
import com.kakao.vectormap.LatLng
import com.kakao.vectormap.label.LabelLayerOptions
import com.kakao.vectormap.label.LabelOptions
import com.kakao.vectormap.label.LabelStyle
import com.kakao.vectormap.label.LabelStyles


class CurrentLocationMarkerManager(private val applicationContext: ReactApplicationContext) {
  private var markerOption: CurrentLocationMarkerOption? = null
  private val markerId = "current-location-marker"
  var enabled: Boolean = false
  private val drawableHelper = ResourceDrawableIdHelper.getInstance()
  private val layerOption: LabelLayerOptions = LabelLayerOptions.from("currentLocationMarker")

  fun loadOption(markerOptionMap: ReadableMap?) {
    if (markerOptionMap == null) {
      markerOption = null
    }
    markerOptionMap!!
    val markerImage = markerOptionMap.getString("markerImage")
    if (markerImage == null) {
      markerOption = null
      return
    }
    val offsetX = if (markerOptionMap.hasKey("offsetX")) markerOptionMap.getDouble("offsetX") else 0.5
    val offsetY = if (markerOptionMap.hasKey("offsetY")) markerOptionMap.getDouble("offsetY") else 1.0
    val latitude = if (markerOptionMap.hasKey("latitude")) markerOptionMap.getDouble("latitude") else 0.0
    val longitude = if (markerOptionMap.hasKey("longitude")) markerOptionMap.getDouble("longitude") else 0.0
    val angle = if (markerOptionMap.hasKey("angle")) markerOptionMap.getDouble("angle") else 0.0
    val rotateMap = if (markerOptionMap.hasKey("rotateMap")) markerOptionMap.getBoolean("rotateMap") else false

    markerOption = CurrentLocationMarkerOption(markerImage, offsetX, offsetY, latitude, longitude, angle, rotateMap)
  }

  fun show(kakaoMap: KakaoMap?) {
    enabled = true
    if (kakaoMap == null){
      return
    }
    if (markerOption == null) {
      return
    }
    val option = markerOption!!
    val markerDrawable = drawableHelper.getResourceDrawableId(applicationContext, option.markerImage)
    val style = LabelStyle.from(markerDrawable)
    style.setAnchorPoint(option.offsetX.toFloat(), option.offsetY.toFloat())
    val labelStyles = LabelStyles.from(style)
    val labelOptions = LabelOptions.from(markerId, LatLng.from(option.latitude, option.longitude))
    labelOptions.setStyles(labelStyles)
    labelOptions.visible = true
    val locationLabel = kakaoMap.labelManager?.addLayer(layerOption)?.addLabel(labelOptions)
    locationLabel?.styles = labelStyles
    locationLabel?.show()
    locationLabel?.rotateTo(Math.toRadians(option.angle).toFloat())

    kakaoMap.trackingManager?.startTracking(locationLabel)
    kakaoMap.trackingManager?.setTrackingRotation(option.rotateMap)
  }
  fun hide(kakaoMap: KakaoMap?) {
    enabled = false
    if (kakaoMap == null){
      return
    }
    kakaoMap.trackingManager?.stopTracking()
    kakaoMap.labelManager?.getLayer(layerOption.getLayerId())?.removeAll()

  }

  fun updateVisibility(kakaoMap: KakaoMap) {
    if (enabled){
      show(kakaoMap)
    } else {
      hide(kakaoMap)
    }
  }
}
