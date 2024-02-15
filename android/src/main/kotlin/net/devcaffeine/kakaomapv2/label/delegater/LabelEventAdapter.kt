package net.devcaffeine.kakaomapv2.label.delegater

interface LabelEventAdapter {
  fun onLabelClick(layerId: String, labelId: String): Boolean
}
