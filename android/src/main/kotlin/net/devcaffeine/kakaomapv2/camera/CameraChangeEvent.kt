import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.events.Event

class CameraChangeEvent(surfaceId: Int, viewId: Int, private val payload: WritableMap?): Event<CameraChangeEvent>(surfaceId, viewId) {
  override fun getEventName() = "onCameraChange"

  override fun getEventData() = payload
}
