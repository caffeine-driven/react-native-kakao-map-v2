import type { RouteLine } from '../../src/lines';

import data from '../resources/route.json';

const segments = data.map((lineData) => ({
  lineWidth: lineData.width,
  lineColor: lineData.color,
  coordinates: lineData.coords,
  strokeWidth: lineData.strokeWidth || undefined,
  strokeColor: lineData.strokeColor || undefined,
}));

export const lines: RouteLine[] = [
  {
    id: '123',
    segments,
  },
];
