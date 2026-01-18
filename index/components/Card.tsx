
import React from 'react';
import { CardData, CardType } from '../types';
import { RARITY_BG } from '../constants';

interface CardProps {
  card: CardData;
  onClick: (card: CardData) => void;
  playerPower: number;
  isReachable: boolean;
}

const Card: React.FC<CardProps> = ({ card, onClick, playerPower, isReachable }) => {
  const { isFlipped, isRevealed, type, value, icon, name, rarity, isBoss, affix } = card;

  // Visual cues
  const isMonster = type === CardType.MONSTER;
  const isTrap = type === CardType.TRAP;
  const isChest = type === CardType.CHEST;
  const isKey = type === CardType.KEY;
  const isShrine = type === CardType.SHRINE;
  
  const canDefeat = isMonster && playerPower >= value;
  const damage = isMonster ? Math.max(0, value - playerPower) : 0;
  
  const isVisible = isFlipped || isRevealed;
  const isInteractable = (!isFlipped && isReachable); 

  // Affix Badges
  const getAffixBadge = () => {
      if (!affix || affix === 'none') return null;
      if (affix === 'heavy') return <span className="text-[9px] bg-gray-700 text-gray-300 px-1 rounded border border-gray-500">🛡️Tank</span>;
      if (affix === 'sharp') return <span className="text-[9px] bg-red-900 text-red-200 px-1 rounded border border-red-500">🗡️Sharp</span>;
      if (affix === 'toxic') return <span className="text-[9px] bg-green-900 text-green-200 px-1 rounded border border-green-500">☠️Toxic</span>;
      if (affix === 'cursed') return <span className="text-[9px] bg-purple-900 text-purple-200 px-1 rounded border border-purple-500">🔮Cursed</span>;
      return null;
  };

  const getCardBg = () => {
      if (isTrap) return 'bg-red-950 border-red-800';
      if (isChest) return 'bg-yellow-900 border-yellow-700';
      if (isKey) return 'bg-slate-800 border-slate-600';
      if (isShrine) return 'bg-indigo-950 border-indigo-700';
      return RARITY_BG[rarity];
  };

  return (
    <div 
      className={`relative w-full aspect-[4/5] perspective-1000 group transition-all duration-300 select-none 
        ${isInteractable ? 'cursor-pointer hover:scale-[1.03] active:scale-95' : 'cursor-default'}
      `}
      onClick={() => isInteractable && onClick(card)}
    >
      <div className={`w-full h-full duration-500 preserve-3d transition-transform ${isVisible ? 'rotate-y-180' : ''}`}>
        
        {/* Front */}
        <div className={`absolute inset-0 backface-hidden rounded-lg border-2 flex items-center justify-center shadow-lg transition-colors
            ${isReachable 
                ? 'bg-slate-700 border-slate-500 hover:border-yellow-400/50 hover:shadow-yellow-400/20' 
                : 'bg-slate-900 border-slate-800 opacity-60'}
        `}>
          {isReachable && <span className="text-3xl opacity-20 font-art">?</span>}
          {!isReachable && <span className="text-xl text-black opacity-30">⛓️</span>}
        </div>

        {/* Back */}
        <div className={`absolute inset-0 backface-hidden rotate-y-180 rounded-lg border-2 flex flex-col items-center justify-between p-1 shadow-xl overflow-hidden
            ${getCardBg()} 
            ${isBoss ? 'danger-pulse border-red-500' : ''}
            ${isRevealed && !isFlipped ? 'opacity-70 grayscale-[0.3]' : ''} 
        `}>
          
          {isRevealed && !isFlipped && (
              <div className="absolute inset-0 bg-blue-500/10 pointer-events-none z-10 flex items-center justify-center">
                  <span className="text-4xl opacity-30 animate-pulse">👁️</span>
              </div>
          )}

          {/* Name */}
          <div className={`text-[10px] w-full text-center truncate px-1 mt-1 leading-tight font-bold z-0 relative flex justify-center gap-1 items-center
             ${isBoss ? 'text-red-400' : 'text-slate-300'}
             ${isTrap ? 'text-orange-400' : ''}
             ${isChest ? 'text-yellow-400' : ''}
          `}>
            {name}
          </div>

          {/* Icon */}
          <div className="flex-1 flex flex-col items-center justify-center relative w-full z-0">
            <span className={`drop-shadow-lg transform transition-transform group-hover:scale-110 
                ${isBoss ? 'text-5xl animate-bounce' : 'text-4xl'}
                ${isTrap ? 'text-red-500' : ''}
                ${isChest ? 'text-yellow-500' : ''}
                ${isShrine ? 'text-indigo-400' : ''}
            `}>
                {icon}
            </span>
            {isMonster && <div className="mt-1">{getAffixBadge()}</div>}
          </div>
            
          {/* Values */}
          {isVisible && (
            <div className="absolute -bottom-2 translate-y-1 w-full flex justify-center">
                {isMonster && (
                        <div className={`text-[10px] font-bold bg-black/90 px-2 py-0.5 rounded-full border shadow-sm ${isBoss ? 'border-red-500 text-red-100' : 'border-red-900 text-red-200'}`}>
                            ⚔️ {value}
                        </div>
                )}
                {isTrap && (
                     <div className="text-[10px] font-bold bg-black/90 px-2 py-0.5 rounded-full border border-orange-700 text-orange-500 shadow-sm">
                         -{value} HP
                     </div>
                )}
                {(type === CardType.WEAPON || type === CardType.SHIELD || type === CardType.POTION || type === CardType.TREASURE) && (
                        <div className={`text-[10px] font-bold bg-black/90 px-2 py-0.5 rounded-full border shadow-sm
                        ${type === CardType.WEAPON ? 'border-yellow-700 text-yellow-500' : ''}
                        ${type === CardType.SHIELD ? 'border-blue-700 text-blue-400' : ''}
                        ${type === CardType.POTION ? 'border-green-700 text-green-500' : ''}
                        ${type === CardType.TREASURE ? 'border-yellow-500 text-yellow-300' : ''}
                        `}>
                            +{value} {type === CardType.TREASURE ? 'G' : ''}
                        </div>
                )}
            </div>
          )}

          {/* Footer Info */}
          <div className="w-full h-5 flex items-center justify-center mb-1 z-0">
            {isMonster && (
                <span className={`text-[10px] font-bold px-1 rounded bg-black/50 ${canDefeat ? 'text-green-400' : 'text-red-400'}`}>
                    {canDefeat ? 'WIN' : `-${damage} HP`}
                </span>
            )}
             {type === CardType.PORTAL && <span className="text-[10px] text-blue-300 animate-pulse font-bold tracking-widest">NEXT</span>}
             {isChest && <span className="text-[10px] text-yellow-600 font-bold bg-black/50 px-1 rounded">NEED KEY</span>}
             {isShrine && <span className="text-[10px] text-indigo-300 font-bold bg-black/50 px-1 rounded">PRAY</span>}
          </div>
        </div>

      </div>
    </div>
  );
};

export default Card;
