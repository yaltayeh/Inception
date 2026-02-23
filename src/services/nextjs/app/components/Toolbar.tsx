'use client';

import { Tool } from '@/app/types/drawing';
import { COLORS, THEME } from '@/app/constants/drawing';

interface ToolbarProps {
  currentColor: string;
  brushSize: number;
  tool: Tool;
  onColorChange: (color: string) => void;
  onBrushSizeChange: (size: number) => void;
  onToolChange: (tool: Tool) => void;
  onClear: () => void;
  onSave: () => void;
}

export default function Toolbar({
  currentColor,
  brushSize,
  tool,
  onColorChange,
  onBrushSizeChange,
  onToolChange,
  onClear,
  onSave,
}: ToolbarProps) {
  return (
    <>
      {/* Tool Selection */}
      <div className="flex items-center gap-2 bg-white border-4 border-black p-2 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
        <button
          onClick={() => onToolChange('pen')}
          className={`w-10 h-10 flex items-center justify-center border-4 transition-all ${
            tool === 'pen'
              ? `border-black bg-[${THEME.primary}] shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]`
              : 'border-transparent hover:bg-gray-100'
          }`}
          title="Pen"
          style={tool === 'pen' ? { backgroundColor: THEME.primary } : {}}
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5">
            <path d="M21.283 2.717a1.75 1.75 0 00-2.474-1.65l-14 2.917a1.75 1.75 0 00-1.092 1.092l2.917 14A1.75 1.75 0 008.217 21.75h7.566a1.75 1.75 0 001.75-1.75l2.917-14a1.75 1.75 0 00-1.092-2.483l-.083-.067zM10 16.5l-6-6 9-9 6 6-9 9z" />
          </svg>
        </button>
        <button
          onClick={() => onToolChange('brush')}
          className={`w-10 h-10 flex items-center justify-center border-4 transition-all ${
            tool === 'brush'
              ? `border-black bg-[${THEME.primary}] shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]`
              : 'border-transparent hover:bg-gray-100'
          }`}
          title="Brush"
          style={tool === 'brush' ? { backgroundColor: THEME.primary } : {}}
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5">
            <path d="M18.238 4.982a2.187 2.187 0 00-2.06-1.43l-2.526.315a.562.562 0 00-.356.19l-1.278 1.767a.375.375 0 01-.263.165l-1.898.38a.376.376 0 01-.337-.037l-3.5-2.75a1.562 1.562 0 00-2.136.268l-1.875 2.625A1.563 1.563 0 002.49 9.75h-.738a.75.75 0 00-.75.75v2.75c0 .414.336.75.75.75h.738a1.562 1.562 0 001.562-1.375l.18-2.625 5.188 4.063a.562.562 0 00.78 0l3.5-3.5.38 1.898c.074.37-.037.77-.264.992l-1.767 1.278a.562.562 0 00-.19.356l-.315 2.526a2.188 2.188 0 001.43 2.061l2.526-.315a.562.562 0 00.356-.19l1.278-1.767a.375.375 0 01.263-.165l1.898.38a.376.376 0 00.337-.037l3.5-2.75a1.562 1.562 0 00.268-2.136l-1.875-2.625A1.562 1.562 0 0017.5 4.01l-2.625-.18.182-2.625a1.562 1.562 0 00-1.374-1.561l-2.75-.183a.75.75 0 00-.75.75v2.75c0 .414.336.75.75.75l2.75-.183a1.562 1.562 0 001.561 1.374l2.625.182a.75.75 0 01.75.75v.737zM8.25 14.5l-4.5-4.5 6.5-6.5 4.5 4.5-6.5 6.5z" />
          </svg>
        </button>
        <button
          onClick={() => onToolChange('eraser')}
          className={`w-10 h-10 flex items-center justify-center border-4 transition-all ${
            tool === 'eraser'
              ? `border-black bg-[${THEME.primary}] shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]`
              : 'border-transparent hover:bg-gray-100'
          }`}
          title="Eraser"
          style={tool === 'eraser' ? { backgroundColor: THEME.primary } : {}}
        >
          <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" className="w-5 h-5">
            <path d="M18.719 4.281l-11.313 11.314a2.143 2.143 0 01-.757.487l-4.243 1.07a.75.75 0 01-.939-.94l1.07-4.243a2.143 2.143 0 01.487-.757l11.314-11.314a2.143 2.143 0 013.03 0l1.351 1.351a2.143 2.143 0 010 3.03zM17.1 5.9l-1.422-1.422a.75.75 0 00-1.06 0L5.64 13.456l4.243 4.243 9.19-9.19a.75.75 0 00-1.06-1.06l-1.013.45z" />
          </svg>
        </button>
      </div>

      {/* Color Picker */}
      <div className="flex items-center gap-2 bg-white border-4 border-black p-2 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
        {COLORS.map((color) => (
          <button
            key={color}
            onClick={() => onColorChange(color)}
            className={`w-8 h-8 border-4 transition-transform ${
              currentColor === color && tool !== 'eraser'
                ? 'border-black scale-110 shadow-[2px_2px_0px_0px_rgba(0,0,0,1)]'
                : 'border-transparent hover:scale-110'
            }`}
            style={{ backgroundColor: color }}
          />
        ))}
        <input
          type="color"
          value={currentColor}
          onChange={(e) => onColorChange(e.target.value)}
          className="w-8 h-8 border-4 border-black cursor-pointer"
        />
      </div>

      {/* Brush Size Slider */}
      <div className="flex items-center gap-2 bg-white border-4 border-black p-2 shadow-[4px_4px_0px_0px_rgba(0,0,0,1)]">
        <span className="font-black text-sm">SIZE:</span>
        <input
          type="range"
          min="1"
          max="50"
          value={brushSize}
          onChange={(e) => onBrushSizeChange(Number(e.target.value))}
          className="w-24 h-8 cursor-pointer"
        />
        <span className="font-black text-sm w-6">{brushSize}</span>
      </div>

      <button
        onClick={onClear}
        className="bg-[#3B82F6] border-4 border-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] px-4 py-2 text-lg font-black text-white hover:translate-x-[2px] hover:translate-y-[2px] hover:shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] active:translate-x-[4px] active:translate-y-[4px] active:shadow-none transition-all"
      >
        CLEAR
      </button>

      <button
        onClick={onSave}
        className="bg-[#EC4899] border-4 border-black shadow-[4px_4px_0px_0px_rgba(0,0,0,1)] px-4 py-2 text-lg font-black text-white hover:translate-x-[2px] hover:translate-y-[2px] hover:shadow-[2px_2px_0px_0px_rgba(0,0,0,1)] active:translate-x-[4px] active:translate-y-[4px] active:shadow-none transition-all"
      >
        SAVE
      </button>
    </>
  );
}

