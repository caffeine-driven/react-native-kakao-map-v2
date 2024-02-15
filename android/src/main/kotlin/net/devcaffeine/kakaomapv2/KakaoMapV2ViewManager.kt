package net.devcaffeine.kakaomapv2

import android.graphics.PointF
import android.util.Log
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.UIManagerHelper
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.uimanager.events.Event
import com.kakao.vectormap.KakaoMap
import com.kakao.vectormap.KakaoMapReadyCallback
import com.kakao.vectormap.LatLng
import com.kakao.vectormap.MapLifeCycleCallback
import com.kakao.vectormap.route.RouteLineOptions
import com.kakao.vectormap.route.RouteLineStyle
import com.kakao.vectormap.route.RouteLineStylesSet
import net.devcaffeine.kakaomapv2.event.NativeEventEmitter
import net.devcaffeine.kakaomapv2.event.ViewEventDispatcher
import net.devcaffeine.kakaomapv2.label.balloon.BalloonMarkerManager
import net.devcaffeine.kakaomapv2.camera.KakaoMapCameraManager
import net.devcaffeine.kakaomapv2.label.delegater.LabelEventDelegator
import net.devcaffeine.kakaomapv2.label.lodlabel.LodLabelManager
import net.devcaffeine.kakaomapv2.label.location.CurrentLocationMarkerManager
import net.devcaffeine.kakaomapv2.lines.RouteLineManager


class KakaoMapV2ViewManager(
  private val applicationContext: ReactApplicationContext
) : SimpleViewManager<MapContainerView>(),
  ViewEventDispatcher,
  KakaoMap.OnTerrainClickListener{
  private val tag = "KakaoMapV2View"
  private var mapView: MapContainerView? = null
  private var kakaoMap: KakaoMap? = null
  private var context: ThemedReactContext? = null
  private lateinit var lodLabelManager: LodLabelManager
  private lateinit var balloonMarkerManager: BalloonMarkerManager
  private lateinit var cameraManager: KakaoMapCameraManager
  private lateinit var nativeEventEmitter: NativeEventEmitter
  private lateinit var labelEventListener: LabelEventDelegator
  private lateinit var currentLocationMarkerManager: CurrentLocationMarkerManager
  private val routeLineManager = RouteLineManager()

  override fun getName() = "KakaoMapV2View"

  override fun createViewInstance(reactContext: ThemedReactContext): MapContainerView {
    val mapViewInstance = MapContainerView(reactContext)
    mapViewInstance.start(object : MapLifeCycleCallback() {
      override fun onMapDestroy() {
        Log.i(tag,"onMapDestroy")
      }

      override fun onMapError(error: Exception?) {
        Log.e(tag, "KakaoMap Failed", error)
      }
    }, MapLifecycleHandler())
    mapView = mapViewInstance
    context = reactContext
    nativeEventEmitter = NativeEventEmitter(this, reactContext)
    lodLabelManager = LodLabelManager(applicationContext, nativeEventEmitter)
    balloonMarkerManager = BalloonMarkerManager(applicationContext, nativeEventEmitter)
    cameraManager = KakaoMapCameraManager(nativeEventEmitter)
    labelEventListener = LabelEventDelegator(balloonMarkerManager)
    currentLocationMarkerManager = CurrentLocationMarkerManager(applicationContext)
    return mapViewInstance
  }

  @ReactProp(name = "centerPosition")
  public fun setCenter(view: MapContainerView, camera: ReadableMap){

    if (camera.hasKey("latitude") && camera.hasKey("longitude") && camera.hasKey("zoomLevel")) {
      val latitude = camera.getDouble("latitude")
      val longitude = camera.getDouble("longitude")
      val zoomLevel = camera.getInt("zoomLevel")
      cameraManager.updateCenter(latitude, longitude, zoomLevel)
      if (kakaoMap != null && !currentLocationMarkerManager.enabled) {
        cameraManager.updateCameraCenter(kakaoMap!!)
      }
    }
  }

  @ReactProp(name = "rotate", defaultDouble = 0.0)
  public fun rotateMap(view: MapContainerView, rotate: Double) {
    cameraManager.updateRotation(rotate)
    if (kakaoMap != null && !currentLocationMarkerManager.enabled) {
      cameraManager.updateCameraRotation(kakaoMap!!)
    }
  }
  @ReactProp(name = "tilt", defaultDouble = 0.0)
  public fun tiltMap(view: MapContainerView, tilt: Double) {
    cameraManager.updateTilt(tilt)
    if (kakaoMap != null && !currentLocationMarkerManager.enabled) {
      cameraManager.updateCameraTilt(kakaoMap!!)
    }
  }

  @ReactProp(name = "lodLabels")
  public fun lodLabels(view: MapContainerView, lodLabels: ReadableArray) {
    lodLabelManager.loadLabels(lodLabels)
    lodLabelManager.renderLabels(kakaoMap)
  }

  @ReactProp(name = "balloonLabels")
  public fun loadBalloonLabels(view: MapContainerView, lodLabels: ReadableArray) {
    balloonMarkerManager.loadLabels(lodLabels)
    balloonMarkerManager.render(kakaoMap)
  }

  @ReactProp(name = "selectedBalloonLabel")
  public fun selectedBalloonLabel(view: MapContainerView, labelId: String?) {
    balloonMarkerManager.onSelectLabel(labelId)
  }


  @ReactProp(name = "showCurrentLocationMarker", defaultBoolean = false)
  public fun showCurrentLocationMarker(view: MapContainerView, show: Boolean) {
    if (show){
      currentLocationMarkerManager.show(kakaoMap)
    } else {
      currentLocationMarkerManager.hide(kakaoMap)
    }
  }

  @ReactProp(name = "currentLocationMarkerOption")
  public fun currentLocationMarkerOption(view: MapContainerView, markerOptionMap: ReadableMap?) {
    currentLocationMarkerManager.loadOption(markerOptionMap)
    if (kakaoMap != null) {
      currentLocationMarkerManager.updateVisibility(kakaoMap!!)
    }
  }

  @ReactProp(name = "routeLines")
  public fun routeLines(view: MapContainerView, routeLines: ReadableArray?) {
    routeLineManager.loadLines(routeLines)
    if (kakaoMap != null) {
      routeLineManager.renderLines(kakaoMap!!)
    }
  }
  override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any> {
    return mutableMapOf(
      "onCameraChange" to mapOf("registrationName" to "onCameraChange"),
      "onBalloonLabelSelect" to mapOf("registrationName" to "onBalloonLabelSelect"),
      "onLodLabelSelect" to mapOf("registrationName" to "onLodLabelSelect"),
    )
  }


  inner class MapLifecycleHandler : KakaoMapReadyCallback() {
    override fun onMapReady(kakaoMap: KakaoMap) {
      Log.i(this@KakaoMapV2ViewManager.tag, "KakaoMapV2 has been initialized")
      this@KakaoMapV2ViewManager.kakaoMap = kakaoMap
      kakaoMap.setOnCameraMoveEndListener(this@KakaoMapV2ViewManager.cameraManager)
      kakaoMap.setOnLabelClickListener(this@KakaoMapV2ViewManager.labelEventListener)
      kakaoMap.setOnLodLabelClickListener(this@KakaoMapV2ViewManager.lodLabelManager)
      kakaoMap.setOnTerrainClickListener(this@KakaoMapV2ViewManager)
      lodLabelManager.renderLabels(kakaoMap)
      balloonMarkerManager.render(kakaoMap)
      currentLocationMarkerManager.updateVisibility(kakaoMap)
      routeLineManager.renderLines(kakaoMap)
    }

    override fun getZoomLevel(): Int {
      return cameraManager.getZoomLevel()
    }

    override fun getPosition(): LatLng {
      return cameraManager.getLatLng()
    }
  }

  override fun <T : Event<T>> dispatchEvent(event: T) {
    val dispatcher = UIManagerHelper.getEventDispatcherForReactTag(context, mapView?.id ?: 0)!!
    dispatcher.dispatchEvent(event)
  }

  override fun getViewId(): Int = mapView?.id ?: 0
  override fun getSurfaceId(): Int = context?.surfaceId ?: 0
  override fun onTerrainClicked(kakaoMap: KakaoMap?, position: LatLng?, screenPoint: PointF?) {
//    lodLabelManager.
    balloonMarkerManager.onSelectLabel(null)
  }
}
