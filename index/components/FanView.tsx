import React from 'react';
import { motion } from 'framer-motion';
import { CardStack } from '../types';
import { MOOD_COLORS } from '../constants';
import { X } from 'lucide-react';

interface FanViewProps {
  stacks: CardStack[];
  onClose: () => void;
  onSelectStack: (stackId: string) => void;
}

export const FanView: React.FC<FanViewProps> = ({ stacks, onClose, onSelectStack }) => {
  return (
    <motion.div 
        initial={{ opacity: 0, backdropFilter: "blur(0px)" }}
        animate={{ opacity: 1, backdropFilter: "blur(10px)" }}
        exit={{ opacity: 0, backdropFilter: "blur(0px)" }}
        className="fixed inset-0 z-50 flex flex-col bg-table/80 overflow-y-auto"
    >
        <div className="sticky top-0 p-6 flex justify-between items-center z-10 bg-gradient-to-b from-table to-transparent">
            <h2 className="text-2xl font-serif text-ink font-bold">记忆概览</h2>
            <button 
                onClick={onClose}
                className="p-2 bg-ink/10 rounded-full hover:bg-ink/20 transition-colors text-ink"
            >
                <X size={24} />
            </button>
        </div>

        <div className="p-8 grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6 max-w-6xl mx-auto w-full">
            {stacks.map((stack, i) => {
                const topCard = stack.cards[0];
                return (
                    <motion.div
                        key={stack.id}
                        layoutId={stack.id} // Shared layout ID for smooth transition from table
                        initial={{ scale: 0.8, opacity: 0, y: 50 }}
                        animate={{ scale: 1, opacity: 1, y: 0 }}
                        transition={{ delay: i * 0.05 }}
                        className="aspect-[3/4] rounded-xl relative cursor-pointer group"
                        onClick={() => {
                            onSelectStack(stack.id);
                            onClose();
                        }}
                    >
                         {/* Stack visual cue */}
                         {stack.cards.length > 1 && (
                             <div className="absolute top-0 right-0 -mr-2 -mt-2 bg-ink text-card text-xs font-bold w-6 h-6 rounded-full flex items-center justify-center z-20 shadow-md">
                                 {stack.cards.length}
                             </div>
                         )}

                         <div className="w-full h-full bg-card rounded-xl shadow-card-rest border border-ink/5 p-4 flex flex-col overflow-hidden group-hover:shadow-card-lift transition-shadow duration-300">
                             <div className="h-1.5 w-10 mb-3 rounded-full" style={{ backgroundColor: MOOD_COLORS[topCard.mood] }}></div>
                             <div className="font-serif text-lg font-bold text-ink mb-1">
                                {new Date(topCard.date).getDate()}日 {new Date(topCard.date).getMonth() + 1}月
                             </div>
                             <p className="text-xs text-ink/70 line-clamp-4 font-serif leading-relaxed">
                                 {topCard.content}
                             </p>
                         </div>
                    </motion.div>
                );
            })}
        </div>
    </motion.div>
  );
};