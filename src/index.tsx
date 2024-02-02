import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
} from 'react-native';

const LINKING_ERROR =
  `The package 'react-native-kakao-map-v2' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

type KakaoMapV2Props = {
  color: string;
  style: ViewStyle;
};

const ComponentName = 'KakaoMapV2View';

export const KakaoMapV2View =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<KakaoMapV2Props>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
