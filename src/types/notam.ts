export interface NOTAM {
  identifier: string;
  description: string;
  startTime: string;
  endTime: string;
  coordinates: [number, number][];
}