import React from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { CardStack, DiaryEntry } from '../types';
import { Card } from './Card';
import { X, ArrowLeft } from 'lucide-react';

interface StackDetailProps {
  stack: CardStack;
  onClose: () => void;
  onRequestAnalysis: (entry: DiaryEntry) => void;
}

export const StackDetail: React.FC<StackDetailProps> = ({ stack, onClose, onRequestAnalysis }) => {
  return (
    <div className="fixed inset-0 z-40 bg-black/40 backdrop-blur-sm flex items-center justify-center p-4">
        <motion.div 
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 0.9 }}
            className="bg-table w-full max-w-4xl h-[80vh] rounded-3xl shadow-2xl relative overflow-hidden flex flex-col"
        >
             {/* Header */}
            <div className="p-6 border-b border-ink/5 flex items-center justify-between bg-white/20">
                <div className="flex items-center gap-3">
                    <button onClick={onClose} className="text-ink hover:text-ink-light">
                        <ArrowLeft />
                    </button>
                    <h2 className="text-xl font-serif text-ink font-bold">
                        {stack.title || "收集的记忆"}
                    </h2>
                    <span className="px-2 py-1 bg-ink/5 rounded-md text-xs font-bold text-ink/60">
                        {stack.cards.length} 张卡片
                    </span>
                </div>
            </div>

            {/* Scrollable Horizontal Stream */}
            <div className="flex-1 overflow-x-auto overflow-y-hidden flex items-center p-10 gap-8 hide-scrollbar">
                {stack.cards.map((entry, index) => (
                    <div key={entry.id} className="w-64 h-80 flex-shrink-0 snap-center">
                        <Card 
                            entry={entry} 
                            isStacked={false} 
                            indexInStack={index}
                            stackCount={1}
                            isFlipped={!!entry.aiInsight && false} // Start unflipped in detail view
                            onFlipRequest={() => { /* Handle local flip if needed */ }}
                        />
                    </div>
                ))}
            </div>

             <div className="absolute inset-0 pointer-events-none bg-noise opacity-30"></div>
        </motion.div>
    </div>
  );
};