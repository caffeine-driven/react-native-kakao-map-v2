import type { RouteLine } from '../../src/lines';

import data from '../resources/route.json';

const routes = data.map((lineData, index) => ({
  id: `${index}`,
  segments: [
    {
      lineWidth: lineData.width,
      lineColor: lineData.color,
      coordinates: lineData.coords,
      strokeWidth: lineData.strokeWidth || undefined,
      strokeColor: lineData.strokeColor || undefined,
    },
  ],
}));

export const lines: RouteLine[] = routes;
