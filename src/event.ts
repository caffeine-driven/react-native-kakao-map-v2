import type { CenterPosition } from './camera';

interface CameraChangeEventPayload {
  centerPosition: CenterPosition;
  rotate?: number;
  tilt?: number;
}
export interface CameraChangeEvent {
  cameraPosition: CameraChangeEventPayload;
  gestureType:
    | 'OneFingerDoubleTap'
    | 'TwoFingerSingleTap'
    | 'Pan'
    | 'Rotate'
    | 'Zoom'
    | 'Tilt'
    | 'LongTapAndDrag'
    | 'RotateZoom'
    | 'OneFingerZoom'
    | 'Unknown';
}

export interface BalloonLabelSelectEvent {
  labelId?: string;
}

export interface LodLabelSelectEventEvent {
  labelId: string;
  layerId: string;
}
