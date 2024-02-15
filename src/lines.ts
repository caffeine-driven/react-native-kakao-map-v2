import type { LatLng } from './common';

export interface RouteLine {
  id: string;
  segments: RouteLineSegment[];
}

export interface RouteLineSegment {
  coordinates: LatLng[];
  lineWidth?: number;
  lineColor: string;
  strokeWidth?: number;
  strokeColor?: string;
}
