package net.devcaffeine.kakaomapv2.event

import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

open class NativeEvent(
  surfaceId: Int, viewId: Int,
  private val eventName: String,
  private val payload: WritableMap): Event<NativeEvent>(surfaceId, viewId) {
  override fun getEventName(): String = eventName

  override fun getEventData() = payload

}
