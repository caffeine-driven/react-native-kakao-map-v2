package net.devcaffeine.kakaomapv2.label.balloon

import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.views.imagehelper.ResourceDrawableIdHelper
import com.kakao.vectormap.KakaoMap
import com.kakao.vectormap.label.LabelLayerOptions
import net.devcaffeine.kakaomapv2.event.NativeEventEmitter
import net.devcaffeine.kakaomapv2.label.delegater.LabelEventAdapter

class BalloonMarkerManager(
  private val applicationContext: ReactApplicationContext,
  private val nativeEventEmitter: NativeEventEmitter
): LabelEventAdapter {
  private val drawableHelper = ResourceDrawableIdHelper.getInstance()
  private var balloonMarkers = emptyMap<String, BalloonMarkerAdapter>()
  private val layerOption: LabelLayerOptions = LabelLayerOptions.from("balloonLabelLayer")

  fun loadLabels(balloonLabels: ReadableArray) {
    balloonMarkers = (0 until (balloonLabels.size()))
      .map { balloonLabels.getMap(it) }
      .map { map ->
        val id = map.getString("id")!!
        val title = map.getString("title")!!
        val latitude = map.getDouble("latitude")
        val longitude = map.getDouble("longitude")
        val activeDrawableName = map.getString("activeIcon")
        val inactiveDrawableName = map.getString("inactiveIcon")!!
        val inactiveDrawable =
          drawableHelper.getResourceDrawable(applicationContext, inactiveDrawableName)!!
        val activeDrawable =
          drawableHelper.getResourceDrawable(applicationContext, activeDrawableName)
            ?: inactiveDrawable
        BalloonMarkerAdapter(
          applicationContext,
          id,
          title,
          latitude,
          longitude,
          activeDrawable,
          inactiveDrawable
        )
      }.associateBy {
        it.id
      }
  }
  fun render(kakaoMap: KakaoMap?) {
    val layer = kakaoMap?.labelManager?.addLayer(layerOption) ?: return
    layer.removeAll()
    balloonMarkers.forEach { it.value.render(layer) }
  }

  fun onSelectLabel(labelId: String?) {
    balloonMarkers.values.forEach{
      if (labelId == it.id){
        it.on()
      } else {
        it.off()
      }
    }
  }

  override fun onLabelClick(layerId: String, labelId: String): Boolean {
    if (layerId != layerOption.getLayerId()) {
      return false
    }
    return if (balloonMarkers.containsKey(labelId)) {
      val selected = if(balloonMarkers[labelId]?.active ?: false) {
        null
      } else {
        labelId
      }
      nativeEventEmitter.emitEvent(BalloonLabelSelectEventParam(selected))
      true
    } else {
      false
    }
  }
}
