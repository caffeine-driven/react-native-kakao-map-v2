package net.devcaffeine.kakaomapv2.label.lodlabel

import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import net.devcaffeine.kakaomapv2.event.NativeEventParam

private fun generatePayload(layerId: String, labelId: String): WritableMap {
  val payload = WritableNativeMap()
  payload.putString("labelId", labelId)
  payload.putString("layerId", layerId)
  return payload
}

class LodLabelSelectEventParam(
  layerId: String, labelId: String
): NativeEventParam("onLodLabelSelect", generatePayload(layerId, labelId)
) {
}
