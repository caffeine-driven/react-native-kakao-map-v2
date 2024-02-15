package net.devcaffeine.kakaomapv2.label.lodlabel

import android.graphics.Color
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.views.imagehelper.ResourceDrawableIdHelper
import com.kakao.vectormap.KakaoMap
import com.kakao.vectormap.LatLng
import com.kakao.vectormap.label.LabelOptions
import com.kakao.vectormap.label.LabelStyle
import com.kakao.vectormap.label.LabelTextStyle
import com.kakao.vectormap.label.LodLabel
import com.kakao.vectormap.label.LodLabelLayer
import net.devcaffeine.kakaomapv2.event.NativeEventEmitter

class LodLabelManager(
  private val applicationContext: ReactApplicationContext,
  private val nativeEventEmitter: NativeEventEmitter
): KakaoMap.OnLodLabelClickListener {
  private var labelOptions: List<LabelOptions> = emptyList()

  fun renderLabels(kakaoMap: KakaoMap?) {
    kakaoMap?.labelManager?.lodLayer?.removeAll()
    if (labelOptions.isNotEmpty()) {
      kakaoMap?.labelManager?.lodLayer?.addLodLabels(labelOptions.toTypedArray())
    }
  }
  fun loadLabels(lodLabels: ReadableArray) {
    labelOptions = (0 until (lodLabels.size()))
      .map { labelIdx -> lodLabels.getMap(labelIdx) }
      .map { labelMap ->
        val labelId = labelMap.getString("id")
        val clickable = labelMap.getBoolean("clickable")
        val latitude = labelMap.getDouble("latitude")
        val longitude = labelMap.getDouble("longitude")
        val texts = labelMap.getArray("texts")?.toArrayList()
          ?.map { txt-> txt as String } ?: emptyList()

        val rawStyles = labelMap.getArray("styles")
        val styles = convertStyles(rawStyles)
        val options = LabelOptions.from(labelId, LatLng.from(latitude, longitude))
        options.setStyles(*styles)
        options.texts = texts.toTypedArray()
        options.tag = labelId
        options.clickable = clickable
        options
      }
  }
  private fun convertStyles(rawStyles: ReadableArray?): Array<LabelStyle> {
    return (0 until (rawStyles?.size() ?: 0))
      .map { styleIdx-> rawStyles?.getMap(styleIdx)!! }
      .map { rawStyle->
        val imageDrawableName = rawStyle.getString("icon")
        val iconDrawable = ResourceDrawableIdHelper.getInstance()
          .getResourceDrawableId(applicationContext, imageDrawableName)

        val rawAnchor = rawStyle.getMap("anchorPoint")!!
        val anchorX = rawAnchor.getDouble("x").toFloat()
        val anchorY = rawAnchor.getDouble("y").toFloat()
        val targetZoomLevel = rawStyle.getInt("zoomLevel")
        val rawTxtStyles = rawStyle.getArray("textStyles")
        val txtStyles = convertTextStyles(rawTxtStyles)
        val style = LabelStyle.from(iconDrawable)
        style.setTextStyles(*txtStyles)
        style.setAnchorPoint(anchorX, anchorY)
        style.zoomLevel = targetZoomLevel
        style
      }.toTypedArray()
  }
  private fun convertTextStyles(rawTxtStyles: ReadableArray?): Array<LabelTextStyle> {
    return (0 until (rawTxtStyles?.size() ?: 0))
      .map { txtStyleIdx-> rawTxtStyles?.getMap(txtStyleIdx)!! }
      .map { rawTxtStyle ->
        val colorString = rawTxtStyle.getString("fontColor") ?: "#000000"

        val txtStyle = LabelTextStyle.from(
          rawTxtStyle.getInt("fontSize"), Color.parseColor(colorString)
        )
        if (rawTxtStyle.hasKey("strokeColor")) txtStyle.strokeColor = Color.parseColor(rawTxtStyle.getString("strokeColor"))
        if (rawTxtStyle.hasKey("strokeThickness")) txtStyle.stroke = rawTxtStyle.getInt("strokeThickness")
        if (rawTxtStyle.hasKey("charSpace")) txtStyle.characterSpace = rawTxtStyle.getInt("charSpace")
        if (rawTxtStyle.hasKey("lineSpace")) txtStyle.lineSpace = rawTxtStyle.getDouble("lineSpace").toFloat()
        if (rawTxtStyle.hasKey("aspectRatio")) txtStyle.aspectRatio = rawTxtStyle.getDouble("aspectRatio").toFloat()
        txtStyle
      }.toTypedArray()
  }

  override fun onLodLabelClicked(kakaoMap: KakaoMap?, layer: LodLabelLayer?, label: LodLabel?) {
    if (layer?.layerId == null || label?.labelId == null) {
      return
    }
    if(kakaoMap?.labelManager?.lodLayer?.layerId == layer.layerId) {
      nativeEventEmitter.emitEvent(LodLabelSelectEventParam(layer.layerId, label.labelId))
    }
  }
}
