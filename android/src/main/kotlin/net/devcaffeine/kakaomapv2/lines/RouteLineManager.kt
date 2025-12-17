package net.devcaffeine.kakaomapv2.lines

import android.graphics.Color
import com.facebook.react.bridge.ReadableArray
import com.kakao.vectormap.KakaoMap
import com.kakao.vectormap.LatLng
import com.kakao.vectormap.route.RouteLineOptions
import com.kakao.vectormap.route.RouteLineSegment
import com.kakao.vectormap.route.RouteLineStyle
import com.kakao.vectormap.route.RouteLineStyles
import com.kakao.vectormap.route.RouteLineStylesSet

class RouteLineManager {
  private var styleSet: RouteLineStylesSet? = null
  private val lineOptions = mutableListOf<RouteLineOptions>()
  fun renderLines(kakaoMap: KakaoMap) {
    val layer = kakaoMap.routeLineManager?.layer
    layer?.removeAll()
    lineOptions.forEach {
      layer?.addRouteLine(it)
    }
  }
  fun loadLines(lineData: ReadableArray?) {
    lineOptions.clear()
    if (lineData == null) {
      styleSet = null
      return
    }
    styleSet = RouteLineStylesSet.from(mutableListOf())
    for (idx in (0 until lineData.size())) {
      val line = lineData.getMap(idx)!!
      val id = line.getString("id") ?: continue
      val styleSegmentPair = convertSegments(line.getArray("segments"))
      styleSegmentPair.forEach { styleSet?.styles?.add(RouteLineStyles.from(it.first)) }
      val segments = styleSegmentPair.map { it.second }
      lineOptions.add(RouteLineOptions.from(id, segments))
    }

  }

  private fun convertSegments(segmentData: ReadableArray?): List<Pair<RouteLineStyle, RouteLineSegment>> {
    if (segmentData == null){
      return emptyList()
    }
    return (0 until segmentData.size())
      .map { segmentData.getMap(it) }
      .map {
        val coordinates = convertLatLng(it!!.getArray("coordinates"))
        val lineWidth = if(it.hasKey("lineWidth")) it.getDouble("lineWidth") else 16.0
        val lineColor = it.getString("lineColor") ?: "#F0F0F0"
        val strokeWidth = if(it.hasKey("strokeWidth")) it.getDouble("strokeWidth") else 0.0
        val strokeColor = it.getString("strokeColor") ?: "#F0F0F0"
        val style = RouteLineStyle.from(lineWidth.toFloat(), Color.parseColor(lineColor))
        style.setZoomLevel(0)
        if (strokeWidth > 0) {
          style.strokeWidth = strokeWidth.toFloat()
          style.strokeColor = Color.parseColor(strokeColor)
        }
        style to RouteLineSegment.from(coordinates, style)
      }
  }
  private fun convertLatLng(coordinates: ReadableArray?): Array<LatLng> {
    if (coordinates == null) {
      return emptyArray()
    }
    return (0 until coordinates.size())
      .map { coordinates.getMap(it) }
      .map {
        LatLng.from(it!!.getDouble("latitude"), it.getDouble("longitude"))
      }.toTypedArray()
  }
}
