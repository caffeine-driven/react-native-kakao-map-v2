require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-kakao-map-v2"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/caffeine-driven/react-native-kakao-map-v2.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift,cpp}"
#   s.private_header_files = "ios/**/*.h"
  s.public_header_files = "ios/**/*.h"

  install_modules_dependencies(s)
  s.header_dir = "react_native_kakao_map_v2"
  s.dependency 'KakaoMapsSDK', '2.12.10'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    # 모듈 이름을 Swift에서 쓰기 편하게 'KakaoMapV2' 등으로 지정할 수 있습니다.
    'PRODUCT_MODULE_NAME' => 'react_native_kakao_map_v2',
    'HEADER_SEARCH_PATHS' => '"$(PODS_TARGET_SRCROOT)/ios/**"'
  }
  s.resource_bundles = {
    'ReactNativeKakaoMapV2' => ['ios/Resources/*.{png,jpg,jpeg,xcassets}']
  }
end
