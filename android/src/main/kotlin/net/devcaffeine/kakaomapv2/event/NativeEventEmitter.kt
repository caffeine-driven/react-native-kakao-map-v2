package net.devcaffeine.kakaomapv2.event

import com.facebook.react.uimanager.ThemedReactContext

class NativeEventEmitter(
  private val dispatcher: ViewEventDispatcher,
  context: ThemedReactContext) {

  public fun <T : NativeEventParam> emitEvent(param: T) {
    dispatcher.dispatchEvent(NativeEvent(dispatcher.getSurfaceId(), dispatcher.getViewId(), param.getEventName(), param.getEventData()))
  }
}
