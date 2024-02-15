package net.devcaffeine.kakaomapv2.camera

import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import com.kakao.vectormap.GestureType
import net.devcaffeine.kakaomapv2.event.NativeEvent
import net.devcaffeine.kakaomapv2.event.NativeEventParam

private fun generatePayload(
  latitude: Double,
  longitude: Double,
  zoomLevel: Int,
  rotate: Double,
  tilt: Double,
  gestureType: GestureType
): WritableMap {
  val centerPosition = WritableNativeMap()
  centerPosition.putDouble("latitude", latitude)
  centerPosition.putDouble("longitude", longitude)
  centerPosition.putInt("zoomLevel", zoomLevel)
  val cameraPositionValues = WritableNativeMap()
  cameraPositionValues.putMap("centerPosition", centerPosition)
  cameraPositionValues.putDouble("rotate", rotate)
  cameraPositionValues.putDouble("tilt", tilt)
  val payload = WritableNativeMap()
  payload.putMap("cameraPosition", cameraPositionValues)
  payload.putString("gestureType", gestureType.name)
  return payload
}

class CameraChangeEventParam(
  latitude: Double,
  longitude: Double,
  zoomLevel: Int,
  rotate: Double,
  tilt: Double,
  gestureType: GestureType,
) : NativeEventParam(
  "onCameraChange",
  generatePayload(latitude, longitude, zoomLevel, rotate, tilt, gestureType)
)
