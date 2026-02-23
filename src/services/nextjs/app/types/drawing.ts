export type Tool = 'pen' | 'brush' | 'eraser';

export interface Point {
  x: number;
  y: number;
}

export interface DrawingState {
  isDrawing: boolean;
  lastPos: Point;
  currentColor: string;
  brushSize: number;
  tool: Tool;
}

