package net.devcaffeine.kakaomapv2.camera

import android.util.Log
import com.kakao.vectormap.GestureType
import com.kakao.vectormap.KakaoMap
import com.kakao.vectormap.LatLng
import com.kakao.vectormap.camera.CameraAnimation
import com.kakao.vectormap.camera.CameraPosition
import com.kakao.vectormap.camera.CameraUpdate
import com.kakao.vectormap.camera.CameraUpdateFactory
import net.devcaffeine.kakaomapv2.event.NativeEventEmitter

class KakaoMapCameraManager(
  private var latitude: Double,
  private var longitude: Double,
  private var zoomLevel: Int,
  private var rotate: Double,
  private var tilt: Double,
  private val emitter: NativeEventEmitter
) : KakaoMap.OnCameraMoveEndListener {
  private val tag = "KakaoMapSDKV2CameraManager"
  private val cameraAnimation = CameraAnimation.from(300, true, false)
  private val cameraWithoutAnimation = CameraAnimation.from(5, false, false)

  constructor(nativeEventEmitter: NativeEventEmitter) : this(
    37.402005,
    127.108621,
    15,
    0.0,
    0.0,
    nativeEventEmitter
  )

  fun getZoomLevel() = zoomLevel
  fun getLatLng() = LatLng.from(latitude, longitude)

  fun updateCenter(latitude: Double, longitude: Double, zoomLevel: Int) {
    if (latitude == 0.0 || longitude == 0.0 || zoomLevel == 0) {
      return
    }
    this.latitude = latitude
    this.longitude = longitude
    this.zoomLevel = zoomLevel
  }

  fun updateTilt(tilt: Double) {
    this.tilt = tilt
  }

  private fun generateTiltUpdate(): CameraUpdate {
    return CameraUpdateFactory.tiltTo(Math.toRadians(tilt))
  }

  fun updateCameraCenter(kakaoMap: KakaoMap) {
    val cameraPosition = kakaoMap.cameraPosition ?: return

    if (shouldUpdateCenter(cameraPosition)) {
      val newCenter = generateCenter()
      kakaoMap.moveCamera(newCenter, cameraAnimation)
      Log.i(tag, "update center position: $newCenter")
    }
  }

  fun updateCameraRotation(kakaoMap: KakaoMap) {
    val cameraPosition = kakaoMap.cameraPosition ?: return
    if (shouldUpdateRotation(cameraPosition)) {
      val cameraUpdate = generateRotateUpdate()
      kakaoMap.moveCamera(cameraUpdate, cameraAnimation)
//      Log.i(tag, "update rotation angle: ${cameraUpdate.rotationAngle}")
    }
  }

  fun updateCameraTilt(kakaoMap: KakaoMap) {
    val cameraPosition = kakaoMap.cameraPosition ?: return
    if (shouldUpdateTilt(cameraPosition)) {
      kakaoMap.moveCamera(generateTiltUpdate(), cameraWithoutAnimation)
      Log.i(tag, "update tilt angle: ${generateTiltUpdate()}")
    }
  }

  private fun generateCenter(): CameraUpdate =
    CameraUpdateFactory.newCenterPosition(getLatLng(), zoomLevel)

  private fun shouldUpdateCenter(cameraPosition: CameraPosition): Boolean {
    return cameraPosition.position.latitude != latitude
      || cameraPosition.position.longitude != longitude
      || cameraPosition.zoomLevel != zoomLevel
  }

  private fun shouldUpdateRotation(cameraPosition: CameraPosition): Boolean {
    return cameraPosition.rotationAngle != rotate
  }

  private fun shouldUpdateTilt(cameraPosition: CameraPosition): Boolean {
    return cameraPosition.tiltAngle != tilt
  }

  fun updateRotation(rotate: Double) {
    this.rotate = rotate
  }

  private fun generateRotateUpdate(): CameraUpdate {
    return CameraUpdateFactory.rotateTo(Math.toRadians(rotate))
  }

  override fun onCameraMoveEnd(
    kakaoMap: KakaoMap,
    cameraPosition: CameraPosition,
    gestureType: GestureType
  ) {
    if (gestureType == GestureType.Unknown) {
      return
    }

    emitter.emitEvent(
      CameraChangeEventParam(
        cameraPosition.position.latitude,
        cameraPosition.position.longitude,
        cameraPosition.zoomLevel,
        cameraPosition.rotationAngle,
        cameraPosition.tiltAngle,
        gestureType
      )
    )
  }
}
