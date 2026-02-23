'use client';

import { useState, useCallback, useRef } from 'react';
import Canvas from './Canvas';
import Toolbar from './Toolbar';
import { Tool, Point } from '@/app/types/drawing';
import { THEME } from '@/app/constants/drawing';

export default function DrawingApp() {
  const [isDrawing, setIsDrawing] = useState(false);
  const [lastPos, setLastPos] = useState<Point>({ x: 0, y: 0 });
  const [currentColor, setCurrentColor] = useState('#000000');
  const [brushSize, setBrushSize] = useState(8);
  const [tool, setTool] = useState<Tool>('pen');
  const canvasRef = useRef<HTMLCanvasElement | null>(null);

  const getStrokeColor = useCallback(() => {
    if (tool === 'eraser') return '#ffffff';
    return currentColor;
  }, [tool, currentColor]);

  const getStrokeWidth = useCallback(() => {
    let size = brushSize;
    if (tool === 'brush') size = brushSize * 2;
    if (tool === 'eraser') size = brushSize * 1.5;
    return size;
  }, [tool, brushSize]);

  const handleDrawingStart = useCallback((point: Point) => {
    setIsDrawing(true);
    setLastPos(point);
  }, []);

  const handleDrawing = useCallback((point: Point) => {
    setLastPos(point);
  }, []);

  const handleDrawingEnd = useCallback(() => {
    setIsDrawing(false);
  }, []);

  const clearCanvas = useCallback(() => {
    // This would need to be implemented via a ref to the canvas
    // For now, we'll trigger a page reload or use a different approach
    window.location.reload();
  }, []);

  const saveImage = useCallback(() => {
    const canvas = document.querySelector('canvas');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    if (!ctx) return;

    const imageData = ctx.getImageData(0, 0, canvas.width, canvas.height);
    const data = imageData.data;

    let minX = canvas.width, minY = canvas.height, maxX = 0, maxY = 0;
    let hasContent = false;

    for (let y = 0; y < canvas.height; y++) {
      for (let x = 0; x < canvas.width; x++) {
        const i = (y * canvas.width + x) * 4;
        const r = data[i];
        const g = data[i + 1];
        const b = data[i + 2];
        
        if (r < 250 || g < 250 || b < 250) {
          hasContent = true;
          if (x < minX) minX = x;
          if (x > maxX) maxX = x;
          if (y < minY) minY = y;
          if (y > maxY) maxY = y;
        }
      }
    }

    if (!hasContent) {
      const link = document.createElement('a');
      link.download = 'drawing.jpg';
      link.href = canvas.toDataURL('image/jpeg', 0.9);
      link.click();
      return;
    }

    const padding = 10;
    minX = Math.max(0, minX - padding);
    minY = Math.max(0, minY - padding);
    maxX = Math.min(canvas.width, maxX + padding);
    maxY = Math.min(canvas.height, maxY + padding);

    const width = maxX - minX;
    const height = maxY - minY;

    const tempCanvas = document.createElement('canvas');
    tempCanvas.width = width;
    tempCanvas.height = height;
    const tempCtx = tempCanvas.getContext('2d');
    if (!tempCtx) return;

    tempCtx.fillStyle = '#ffffff';
    tempCtx.fillRect(0, 0, width, height);
    tempCtx.drawImage(canvas, minX, minY, width, height, 0, 0, width, height);

    const link = document.createElement('a');
    link.download = 'drawing.jpg';
    link.href = tempCanvas.toDataURL('image/jpeg', 0.9);
    link.click();
  }, []);

  return (
    <div className="fixed inset-0 p-4 font-sans flex flex-col" style={{ backgroundColor: THEME.background }}>
      {/* Header */}
      <div className="flex p-4 items-center justify-between shrink-0 gap-4 flex-wrap">
        <h1 
          className="text-3xl md:text-4xl font-black border-4 border-black shadow-[6px_6px_0px_0px_rgba(0,0,0,1)] px-4 py-2"
          style={{ backgroundColor: THEME.primary, color: THEME.text }}
        >
          DRAW PLANE
        </h1>

        <Toolbar
          currentColor={currentColor}
          brushSize={brushSize}
          tool={tool}
          onColorChange={setCurrentColor}
          onBrushSizeChange={setBrushSize}
          onToolChange={setTool}
          onClear={clearCanvas}
          onSave={saveImage}
        />
      </div>

      {/* Full Screen Canvas */}
      <div className="flex-1 p-4 pt-0">
        <div 
          className="h-full border-4 border-black shadow-[8px_8px_0px_0px_rgba(0,0,0,1)] overflow-hidden"
          style={{ backgroundColor: THEME.canvas }}
        >
          <Canvas
            onDrawingStart={handleDrawingStart}
            onDrawing={handleDrawing}
            onDrawingEnd={handleDrawingEnd}
            isDrawing={isDrawing}
            lastPos={lastPos}
            strokeColor={getStrokeColor()}
            strokeWidth={getStrokeWidth()}
          />
        </div>
      </div>
    </div>
  );
}

