import React from 'react';
import { FloatingText } from '../types';

interface Props {
  items: FloatingText[];
}

const FloatingTextLayer: React.FC<Props> = ({ items }) => {
  return (
    <div className="fixed inset-0 pointer-events-none z-50 overflow-hidden">
      {items.map((item) => (
        <div
          key={item.id}
          className={`absolute font-bold text-2xl animate-float ${item.color} font-num shadow-black drop-shadow-md`}
          style={{ 
            left: item.x, 
            top: item.y,
            textShadow: '2px 2px 0px #000'
          }}
        >
          {item.text}
        </div>
      ))}
    </div>
  );
};

export default FloatingTextLayer;