import {
  requireNativeComponent,
  UIManager,
  Platform,
  type ViewStyle,
  type NativeSyntheticEvent,
} from 'react-native';
import type {
  BalloonLabels,
  CurrentLocationMarkerOption,
  LodLabel,
} from './labels';
import type { CenterPosition } from './camera';
import type {
  BalloonLabelSelectEvent,
  CameraChangeEvent,
  LodLabelSelectEventEvent,
} from './event';
import type { RouteLine } from './lines';

const LINKING_ERROR =
  `The package 'react-native-kakao-map-v2' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '- You are not using Expo Go\n';

export interface KakaoMapV2Props {
  //Camera
  centerPosition?: CenterPosition;
  rotate?: number;
  tilt?: number;
  lodLabels?: LodLabel[];
  balloonLabels?: BalloonLabels[];
  selectedBalloonLabel?: string;
  routeLines?: RouteLine[];
  showCurrentLocationMarker?: boolean;
  currentLocationMarkerOption?: CurrentLocationMarkerOption;
  onCameraChange?: (e: NativeSyntheticEvent<CameraChangeEvent>) => void;
  onBalloonLabelSelect?: (
    e: NativeSyntheticEvent<BalloonLabelSelectEvent>
  ) => void;
  onLodLabelSelect?: (
    e: NativeSyntheticEvent<LodLabelSelectEventEvent>
  ) => void;
}
interface KakaoMapV2ViewProps extends KakaoMapV2Props {
  style: ViewStyle;
}

const ComponentName = 'KakaoMapV2View';

export const KakaoMapV2View =
  UIManager.getViewManagerConfig(ComponentName) != null
    ? requireNativeComponent<KakaoMapV2ViewProps>(ComponentName)
    : () => {
        throw new Error(LINKING_ERROR);
      };
