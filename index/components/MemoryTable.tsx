
import React, { useRef, useState, useEffect } from 'react';
import { motion, AnimatePresence, PanInfo } from 'framer-motion';
import { CardStack, DiaryEntry } from '../types';
import { Card } from './Card';
import { Sparkles, LayoutGrid } from 'lucide-react';

interface MemoryTableProps {
  stacks: CardStack[];
  onStackUpdate: (newStacks: CardStack[]) => void;
  onOpenStack: (stackId: string) => void;
  onRequestAnalysis: (entry: DiaryEntry) => void;
}

export const MemoryTable: React.FC<MemoryTableProps> = ({ 
  stacks, 
  onStackUpdate,
  onOpenStack,
  onRequestAnalysis
}) => {
  const constraintsRef = useRef(null);
  const scrollContainerRef = useRef<HTMLDivElement>(null);
  const [flippedCards, setFlippedCards] = useState<Record<string, boolean>>({});
  const [isDraggingTable, setIsDraggingTable] = useState(false);
  const [startX, setStartX] = useState(0);
  const [scrollLeft, setScrollLeft] = useState(0);

  const handleFlip = (entryId: string, entry: DiaryEntry) => {
    setFlippedCards(prev => {
        const isNowFlipped = !prev[entryId];
        if (isNowFlipped && !entry.aiInsight) {
            onRequestAnalysis(entry);
        }
        return {
            ...prev,
            [entryId]: isNowFlipped
        };
    });
  };

  // Stack Merge Logic
  const handleDragEnd = (event: any, info: PanInfo, activeStack: CardStack) => {
    const dropTarget = stacks.find(target => {
        if (target.id === activeStack.id) return false;
        const element = document.getElementById(`stack-container-${target.id}`);
        if (element) {
            const rect = element.getBoundingClientRect();
            const x = info.point.x;
            const y = info.point.y;
            return (
                x >= rect.left && 
                x <= rect.right && 
                y >= rect.top && 
                y <= rect.bottom
            );
        }
        return false;
    });

    if (dropTarget) {
        const newTargetStack = {
            ...dropTarget,
            cards: [...dropTarget.cards, ...activeStack.cards].sort((a,b) => new Date(b.date).getTime() - new Date(a.date).getTime())
        };
        const remainingStacks = stacks.filter(s => s.id !== activeStack.id && s.id !== dropTarget.id);
        onStackUpdate([...remainingStacks, newTargetStack]);
    }
  };

  // Auto Organize: Group by Mood
  const handleAutoOrganize = () => {
      const moodGroups: Record<string, DiaryEntry[]> = {};
      
      // Flatten all cards first
      const allCards = stacks.flatMap(s => s.cards);
      
      // Group by mood
      allCards.forEach(card => {
          if (!moodGroups[card.mood]) {
              moodGroups[card.mood] = [];
          }
          moodGroups[card.mood].push(card);
      });

      // Create new stacks
      const newStacks: CardStack[] = Object.keys(moodGroups).map((mood, index) => ({
          id: `stack-mood-${mood}-${Date.now()}`,
          title: `${mood === 'joy' ? '开心' : mood === 'calm' ? '平静' : mood === 'anxiety' ? '焦虑' : '忧郁'}时刻`,
          cards: moodGroups[mood].sort((a,b) => new Date(b.date).getTime() - new Date(a.date).getTime()),
          zIndex: index,
          position: { x: 0, y: 0 }
      }));

      onStackUpdate(newStacks);
  };

  // Table Panning Logic (Mouse/Touch Drag on background)
  const handleTableMouseDown = (e: React.MouseEvent) => {
      // Only trigger if clicking directly on the background wrapper
      if(scrollContainerRef.current) {
        setIsDraggingTable(true);
        setStartX(e.pageX - scrollContainerRef.current.offsetLeft);
        setScrollLeft(scrollContainerRef.current.scrollLeft);
      }
  };

  const handleTableMouseLeave = () => setIsDraggingTable(false);
  const handleTableMouseUp = () => setIsDraggingTable(false);
  const handleTableMouseMove = (e: React.MouseEvent) => {
      if(!isDraggingTable || !scrollContainerRef.current) return;
      e.preventDefault();
      const x = e.pageX - scrollContainerRef.current.offsetLeft;
      const walk = (x - startX) * 1.5; // Scroll speed multiplier
      scrollContainerRef.current.scrollLeft = scrollLeft - walk;
  };

  const currentDate = new Date();

  return (
    <div 
        className="w-full h-full relative flex flex-col items-center overflow-hidden cursor-grab active:cursor-grabbing" 
        ref={constraintsRef}
        onMouseDown={handleTableMouseDown}
        onMouseLeave={handleTableMouseLeave}
        onMouseUp={handleTableMouseUp}
        onMouseMove={handleTableMouseMove}
    >
      {/* Table Surface & Noise */}
      <div className="absolute inset-0 bg-table pointer-events-none">
          <div className="w-full h-full bg-noise opacity-50"></div>
      </div>
      <div className="absolute inset-0 bg-gradient-to-b from-white/20 to-black/5 pointer-events-none"></div>

      {/* Header: Time Flow Indicator & Organize Button */}
      <div className="mt-12 mb-4 z-30 flex flex-col items-center select-none relative w-full px-10">
          <div className="flex items-center gap-4">
              <h2 className="text-3xl font-serif text-ink font-bold tracking-tight">
                  {currentDate.getFullYear()}年 <span className="mx-2 text-ink/40">·</span> {currentDate.getMonth() + 1}月
              </h2>
          </div>
          <div className="h-1 w-12 bg-ink/10 mt-4 rounded-full"></div>
          
          {/* Organize Button */}
          <motion.button
            whileHover={{ scale: 1.05 }}
            whileTap={{ scale: 0.95 }}
            onClick={(e) => { e.stopPropagation(); handleAutoOrganize(); }}
            className="absolute right-10 top-2 px-4 py-2 bg-white/40 hover:bg-white/60 backdrop-blur-md rounded-full border border-white/40 text-ink text-sm font-bold flex items-center gap-2 shadow-sm transition-colors z-40"
          >
              <Sparkles size={16} className="text-joy" />
              <span>一键整理</span>
          </motion.button>
      </div>

      {/* Main Scrollable Card Area */}
      <div 
        ref={scrollContainerRef}
        className="relative flex-1 w-full overflow-x-auto hide-scrollbar flex items-center"
        style={{ scrollBehavior: 'smooth' }}
      >
        <div className="flex items-center gap-8 px-[50vw] min-w-max h-96 py-10">
            {/* Virtual Slots (Background Hints) - positioned relative to content */}
            <div className="absolute left-1/2 top-1/2 -translate-y-1/2 -translate-x-1/2 flex gap-16 opacity-10 pointer-events-none">
                <div className="w-64 h-80 border-2 border-dashed border-ink rounded-2xl transform -translate-x-32 -rotate-2"></div>
                <div className="w-64 h-80 border-2 border-dashed border-ink rounded-2xl transform translate-x-32 rotate-2"></div>
            </div>

            <AnimatePresence>
            {stacks.map((stack, index) => {
                const isSingle = stack.cards.length === 1;
                const topCard = stack.cards[0];
                
                return (
                <motion.div
                    key={stack.id}
                    layoutId={stack.id}
                    id={`stack-container-${stack.id}`}
                    initial={{ opacity: 0, y: 150, rotate: Math.random() * 20 - 10 }}
                    animate={{ opacity: 1, y: 0, rotate: (index % 2 === 0 ? 2 : -2) + (Math.random() * 2 - 1) }}
                    exit={{ opacity: 0, scale: 0.5, transition: { duration: 0.2 } }}
                    transition={{ 
                        type: "spring", 
                        stiffness: 100, 
                        damping: 20, 
                        delay: index * 0.08 
                    }}
                    drag
                    // Remove constraint to allow dragging anywhere to organize
                    dragElastic={0.2}
                    onDragStart={(e) => e.stopPropagation()} // Prevent table panning when dragging card
                    onDragEnd={(e, info) => handleDragEnd(e, info, stack)}
                    whileDrag={{ scale: 1.1, zIndex: 100, rotate: 0, boxShadow: "0 25px 50px -12px rgba(0, 0, 0, 0.25)" }}
                    whileHover={{ y: -10, transition: { duration: 0.2 } }}
                    className="relative w-64 h-80 flex-shrink-0 cursor-grab active:cursor-grabbing"
                    style={{ zIndex: stack.zIndex, perspective: 1000 }}
                >
                    <div 
                        onClick={(e) => {
                             e.stopPropagation(); 
                             if(stack.cards.length > 1) onOpenStack(stack.id);
                        }} 
                        className="w-full h-full"
                    >
                        <Card 
                            entry={topCard} 
                            isStacked={!isSingle} 
                            stackCount={stack.cards.length}
                            isFlipped={flippedCards[topCard.id]}
                            onFlipRequest={() => handleFlip(topCard.id, topCard)}
                            indexInStack={0}
                        />
                    </div>
                </motion.div>
                );
            })}
            </AnimatePresence>
        </div>
      </div>

      {stacks.length === 0 && (
          <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 text-ink/30 font-serif italic text-lg text-center pointer-events-none">
              牌桌空空如也。<br/>发一张牌开始吧。
          </div>
      )}
    </div>
  );
};
