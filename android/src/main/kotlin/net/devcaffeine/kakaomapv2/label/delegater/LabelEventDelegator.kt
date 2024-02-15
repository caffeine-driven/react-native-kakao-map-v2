package net.devcaffeine.kakaomapv2.label.delegater

import com.kakao.vectormap.KakaoMap
import com.kakao.vectormap.label.Label
import com.kakao.vectormap.label.LabelLayer

class LabelEventDelegator(vararg adapter: LabelEventAdapter) : KakaoMap.OnLabelClickListener {
  private val adapters: List<LabelEventAdapter>
  init {
      adapters = adapter.toList()
  }
  override fun onLabelClicked(kakaoMap: KakaoMap?, layer: LabelLayer?, label: Label?) {
    val layerId = layer?.layerId
    val labelId = label?.labelId
    if (labelId == null || layerId == null){
      return
    }
    for (adapter in adapters) {
      val triggered = adapter.onLabelClick(layerId, labelId)
      if (triggered){
        break
      }
    }
  }
}
