package net.devcaffeine.kakaomapv2.label.balloon

import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.WritableNativeMap
import net.devcaffeine.kakaomapv2.event.NativeEventParam

private fun generatePayload(labelId: String?): WritableMap{
  val payload = WritableNativeMap()
  payload.putString("labelId", labelId)
  return payload
}

class BalloonLabelSelectEventParam(
  labelId: String?
): NativeEventParam("onBalloonLabelSelect", generatePayload(labelId))
