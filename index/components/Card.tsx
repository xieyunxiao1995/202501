import React from 'react';
import { motion, PanInfo } from 'framer-motion';
import { DiaryEntry } from '../types';
import { MOOD_COLORS } from '../constants';
import { Sparkles, MapPin, RotateCw, ImageIcon } from 'lucide-react';

interface CardProps {
  entry: DiaryEntry;
  isStacked?: boolean;
  stackCount?: number;
  onFlipRequest?: () => void;
  isFlipped?: boolean;
  onDragEnd?: (e: MouseEvent | TouchEvent | PointerEvent, info: PanInfo) => void;
  indexInStack: number;
}

const formatDate = (dateStr: string) => {
  const date = new Date(dateStr);
  return {
    day: date.getDate(),
    month: date.getMonth() + 1, // Month is 0-indexed
    year: date.getFullYear(),
    weekday: date.toLocaleDateString('zh-CN', { weekday: 'long' }),
  };
};

export const Card: React.FC<CardProps> = ({ 
  entry, 
  isStacked = false, 
  stackCount = 1,
  onFlipRequest,
  isFlipped = false,
  onDragEnd
}) => {
  const variants = {
    front: { rotateY: 0 },
    back: { rotateY: 180 },
  };

  const { day, month, year, weekday } = formatDate(entry.date);
  const moodColor = MOOD_COLORS[entry.mood];

  // Visual offsets for stacked effect
  const stackOffsets = isStacked && stackCount > 1 
    ? Array.from({ length: Math.min(stackCount - 1, 2) }).map((_, i) => i + 1) 
    : [];

  // Generate a geometric pattern for the back based on mood/id
  const getPatternStyle = () => {
      const color = moodColor;
      if (entry.mood === 'joy') {
          return { backgroundImage: `repeating-linear-gradient(45deg, ${color}22 0, ${color}22 10px, transparent 10px, transparent 20px)` };
      } else if (entry.mood === 'calm') {
          return { backgroundImage: `radial-gradient(${color}22 2px, transparent 2px)`, backgroundSize: '16px 16px' };
      } else if (entry.mood === 'anxiety') {
          return { backgroundImage: `repeating-linear-gradient(90deg, ${color}22 0, ${color}22 2px, transparent 2px, transparent 8px)` };
      } else {
           return { backgroundImage: `linear-gradient(135deg, ${color}22 25%, transparent 25%), linear-gradient(225deg, ${color}22 25%, transparent 25%), linear-gradient(45deg, ${color}22 25%, transparent 25%), linear-gradient(315deg, ${color}22 25%, transparent 25%)`, backgroundSize: '20px 20px' };
      }
  };

  return (
    <div className="relative w-full h-full preserve-3d cursor-grab active:cursor-grabbing perspective-1000">
        {/* Fake underlying cards for stack effect */}
        {stackOffsets.map((offset) => (
            <div
                key={`stack-layer-${offset}`}
                className="absolute w-full h-full rounded-2xl bg-card border border-ink/5 shadow-sm"
                style={{
                    top: offset * 4,
                    left: 0,
                    zIndex: -offset,
                    transform: `scale(${1 - offset * 0.02})`,
                    backgroundColor: '#F0EEE9' 
                }}
            />
        ))}

      <motion.div
        className="relative w-full h-full"
        initial="front"
        animate={isFlipped ? "back" : "front"}
        variants={variants}
        transition={{ duration: 0.6, type: "spring", stiffness: 260, damping: 20 }}
        style={{ transformStyle: "preserve-3d" }}
      >
        {/* FRONT FACE */}
        <div 
          className="absolute inset-0 w-full h-full bg-card rounded-2xl shadow-card-rest border border-white/60 flex flex-col overflow-hidden backface-hidden"
          style={{ backfaceVisibility: 'hidden' }}
        >
          {/* Header */}
          <div className="h-2 w-full" style={{ backgroundColor: moodColor }}></div>
          <div className="p-5 flex-1 flex flex-col overflow-hidden">
            <div className="flex justify-between items-start mb-4">
              <div className="flex flex-col">
                <div className="flex items-baseline gap-1">
                    <span className="text-3xl font-serif text-ink font-bold">{day}</span>
                    <span className="text-sm font-serif text-ink font-bold">日</span>
                </div>
                <span className="text-xs font-sans text-ink-light tracking-widest">{year}年{month}月</span>
              </div>
              <div className="flex flex-col items-end">
                <span className="text-xs font-hand text-ink-light opacity-60">{weekday}</span>
                {entry.location && (
                  <div className="flex items-center text-[10px] text-ink-light mt-1">
                    <MapPin size={10} className="mr-1" />
                    {entry.location}
                  </div>
                )}
              </div>
            </div>

            {/* Content Container */}
            <div className="flex-1 relative overflow-y-auto hide-scrollbar pr-1">
               {/* Lined Paper Effect */}
               <div className="absolute inset-0 w-full min-h-full pointer-events-none opacity-10"
                    style={{ backgroundImage: 'linear-gradient(#4A4238 1px, transparent 1px)', backgroundSize: '100% 24px' }}>
               </div>
               
               {/* Photo Attachment (Tape Style) */}
               {entry.image && (
                 <div className="relative mb-4 rotate-1 transform mx-2">
                     <div className="absolute -top-3 left-1/2 -translate-x-1/2 w-8 h-4 bg-white/40 border-l border-r border-white/60 rotate-2 z-10 backdrop-blur-sm shadow-sm"></div>
                     <div className="p-1 bg-white shadow-md">
                        <img src={entry.image} alt="Memory" className="w-full h-32 object-cover grayscale-[20%] sepia-[10%]" />
                     </div>
                 </div>
               )}

               <p className="font-serif text-ink text-base leading-relaxed relative z-0 whitespace-pre-wrap">
                 {entry.content}
               </p>
            </div>
            
            {/* Footer Actions */}
            <div className="mt-2 pt-3 border-t border-ink/5 flex justify-between items-center flex-shrink-0">
                <div className="flex gap-2">
                    {stackCount > 1 && (
                         <span className="px-2 py-0.5 bg-ink/5 text-ink text-[10px] rounded-full font-bold">
                            堆叠 x{stackCount}
                         </span>
                    )}
                </div>
                <button 
                    onClick={(e) => { e.stopPropagation(); onFlipRequest && onFlipRequest(); }}
                    className="p-2 hover:bg-black/5 rounded-full transition-colors text-ink-light"
                >
                    <RotateCw size={16} />
                </button>
            </div>
          </div>
          
          {/* Inner Highlight for 3D feel */}
          <div className="absolute inset-0 rounded-2xl shadow-inner-light pointer-events-none"></div>
        </div>

        {/* BACK FACE */}
        <div 
          className="absolute inset-0 w-full h-full bg-card-back rounded-2xl shadow-card-rest border border-black/5 flex flex-col backface-hidden overflow-hidden"
          style={{ 
              transform: "rotateY(180deg)", 
              backfaceVisibility: 'hidden',
          }}
        >
            {/* Geometric Pattern Overlay */}
            <div className="absolute inset-0 opacity-40 pointer-events-none" style={getPatternStyle()}></div>

            <div className="relative z-10 flex-1 flex flex-col items-center justify-center p-6 text-center">
                <div className="mb-4 p-3 bg-white/20 backdrop-blur-sm rounded-full shadow-sm text-ink">
                    <Sparkles size={24} color={moodColor} fill={moodColor} />
                </div>
                
                <h3 className="font-serif font-bold text-ink mb-2">灵感时刻</h3>
                <p className="font-serif text-sm text-ink/80 italic mb-6 leading-relaxed">
                    "{entry.aiInsight || '点击翻转，看看 AI 说什么...'}"
                </p>

                <div className="flex flex-wrap gap-2 justify-center">
                    {entry.aiTags?.map(tag => (
                        <span key={tag} className="px-3 py-1 bg-white/30 backdrop-blur-md rounded-full text-xs font-semibold text-ink border border-white/20">
                            #{tag}
                        </span>
                    ))}
                </div>
            </div>
            <div className="relative z-10 p-4 border-t border-black/5 flex justify-center">
                <button 
                    onClick={(e) => { e.stopPropagation(); onFlipRequest && onFlipRequest(); }}
                    className="text-xs font-bold text-ink/50 uppercase tracking-widest hover:text-ink"
                >
                    翻回正面
                </button>
            </div>
             {/* Texture Overlay */}
             <div className="absolute inset-0 rounded-2xl bg-noise opacity-30 pointer-events-none mix-blend-multiply"></div>
        </div>
      </motion.div>
    </div>
  );
};