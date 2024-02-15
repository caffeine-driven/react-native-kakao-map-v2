package net.devcaffeine.kakaomapv2.label.balloon

import android.content.Context
import android.graphics.drawable.Drawable
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ImageView
import android.widget.LinearLayout
import android.widget.TextView
import com.kakao.vectormap.LatLng
import com.kakao.vectormap.label.Label
import com.kakao.vectormap.label.LabelLayer
import com.kakao.vectormap.label.LabelOptions
import com.kakao.vectormap.label.LabelStyle
import com.kakao.vectormap.label.LabelStyles
import net.devcaffeine.kakaomapv2.R
import net.devcaffeine.kakaomapv2.ViewToBitmap

class BalloonMarkerAdapter(
  context: Context,
  val id: String, text: String,
  private val latitude: Double, longitude: Double,
  activeMarkerDrawable: Drawable,
  inactiveMarkerDrawable: Drawable,
) {
  private val labelOptions: LabelOptions
  private val activeStyle: LabelStyles
  private val inactiveStyle: LabelStyles
  var active = false
  private lateinit var label: Label
  init {
    val activeViewGroup = LayoutInflater.from(context).inflate(R.layout.layout_balloon, null) as ViewGroup
    val tv = activeViewGroup.findViewById<TextView>(R.id.tv_callout_balloon)
    val iv = activeViewGroup.findViewById<ImageView>(R.id.iv_marker_img)
    tv.text = text
    iv.setImageDrawable(activeMarkerDrawable)
    activeStyle = LabelStyles.from(LabelStyle.from(ViewToBitmap.createBitmap(activeViewGroup)))

    val inactiveViewGroup = LayoutInflater.from(context).inflate(R.layout.layout_balloon, null) as ViewGroup
    val inactiveImageVIew = inactiveViewGroup.findViewById<ImageView>(R.id.iv_marker_img)
    val balloonWrapper = inactiveViewGroup.findViewById<LinearLayout>(R.id.balloon_wrapper)
    inactiveImageVIew.setImageDrawable(inactiveMarkerDrawable)
    balloonWrapper.visibility = View.INVISIBLE
    inactiveStyle = LabelStyles.from(LabelStyle.from(ViewToBitmap.createBitmap(inactiveViewGroup)))

    labelOptions = LabelOptions.from(id, LatLng.from(latitude, longitude))
      .setStyles(inactiveStyle)
      .setVisible(true)
    active = false

  }

  fun render(layer: LabelLayer): Label{
    label = layer.addLabel(
      labelOptions
    )!!
    return label
  }

  fun toggle() {
    if (active) {
      off()
    } else {
      on()
    }
  }
  fun on() {
    label.changeStyles(activeStyle)
    active = true
  }
  fun off() {
    label.changeStyles(inactiveStyle)
    active = false
  }
}
