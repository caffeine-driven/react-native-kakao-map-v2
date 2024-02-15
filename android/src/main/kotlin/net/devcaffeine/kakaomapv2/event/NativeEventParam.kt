package net.devcaffeine.kakaomapv2.event

import com.facebook.react.bridge.WritableMap

open class NativeEventParam(
  private val eventName: String,
  private val payload: WritableMap
) {
  fun getEventName(): String = eventName

  fun getEventData() = payload
}
