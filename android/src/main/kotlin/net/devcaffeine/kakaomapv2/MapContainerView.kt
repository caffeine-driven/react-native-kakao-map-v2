package net.devcaffeine.kakaomapv2

import android.content.Context
import android.widget.RelativeLayout
import com.kakao.vectormap.KakaoMapReadyCallback
import com.kakao.vectormap.MapLifeCycleCallback
import com.kakao.vectormap.MapView

class MapContainerView(context: Context?) : RelativeLayout(context) {
  private var mapView: MapView
  init {
    inflate(context, R.layout.layout_map_container, this)
    mapView = findViewById(R.id.map_view)
  }

//  public fun start(vararg readyCallback: KakaoMapReadyCallback) {
//    mapView.start(*readyCallback)
//
//  }

  public fun start(lifeCycleCallback: MapLifeCycleCallback, vararg readyCallback: KakaoMapReadyCallback) {
    mapView.start(lifeCycleCallback, *readyCallback)
  }
}
