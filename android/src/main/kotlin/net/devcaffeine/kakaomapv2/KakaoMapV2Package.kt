package net.devcaffeine.kakaomapv2

import android.content.pm.PackageManager
import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.kakao.vectormap.KakaoMapSdk


class KakaoMapV2Package : ReactPackage {
  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
    return emptyList()
  }

  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {

    val bundle = reactContext.packageManager.getApplicationInfo(
      reactContext.packageName,
      PackageManager.GET_META_DATA
    ).metaData
    val kakaoMapKey = bundle.getString("com.kakao.vectormap.APP_KEY")
    KakaoMapSdk.init(reactContext, kakaoMapKey!!)
    return listOf(KakaoMapV2ViewManager(reactContext))
  }
}
