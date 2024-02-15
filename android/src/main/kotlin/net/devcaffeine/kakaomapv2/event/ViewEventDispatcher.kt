package net.devcaffeine.kakaomapv2.event

import com.facebook.react.uimanager.events.Event

interface ViewEventDispatcher {
  fun <T: Event<T>> dispatchEvent(event: T)
  fun getViewId(): Int

  fun getSurfaceId(): Int
}
