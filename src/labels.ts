import type { LatLng } from './common';

interface AnchorPoint {
  x: number;
  y: number;
}

//Badge의 ZOrder는 array의 순서대로 결정, 0이 가장 높음
// export interface Badge {
//   id: string;
//   icon: ImageSourcePropType;
//   offset: AnchorPoint;
//   zOrder: number;
// }

export interface TextStyle {
  fontSize: number;
  fontColor?: string; //black
  strokeColor?: string;
  strokeThickness?: number;
  charSpace?: number;
  lineSpace?: number;
  aspectRatio?: number;
}

export interface LabelStyle {
  icon: string;
  anchorPoint: AnchorPoint;
  // transitionType: 'NONE' | 'ALPHA' | 'SCALE'
  // badges: Badge[];
  zoomLevel: number;
  textStyles: TextStyle[];
}

// Unsupported
// export interface Label {
//   id: string;
//   styles: LabelStyle[];
// }

export interface LodLabel extends LatLng {
  id: string;
  styles: LabelStyle[];
  clickable: boolean;
  texts: string[];
}

// export interface LabelLayer {
//   id: string;
//   zOrder: number;
//   visible: boolean;
//   lodLabel: LodLabel[];
// }

export interface BalloonLabels extends LatLng {
  id: string;
  title: string;
  activeIcon: string;
  inactiveIcon: string;
}

export interface CurrentLocationMarkerOption extends LatLng {
  markerImage: string;
  angle?: number;
  rotateMap?: boolean;
  offsetX?: number;
  offsetY?: number;
}
