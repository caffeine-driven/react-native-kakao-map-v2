import type { LatLng } from './common';

export interface CenterPosition extends LatLng {
  zoomLevel: number;
}
