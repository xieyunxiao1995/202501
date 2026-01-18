
import React, { useState, useEffect, useRef } from 'react';
import { CardData, CardType, GameState, PlayerStats, FloatingText, ShopItem, ClassConfig, Perk } from './types';
import { generateLevel } from './utils/gameLogic';
import { INITIAL_PLAYER_STATS, GRID_COLS, CLASSES, RELICS, PERKS } from './constants';
import Card from './components/Card';
import FloatingTextLayer from './components/FloatingTextLayer';

const App: React.FC = () => {
  // Game State
  const [gameState, setGameState] = useState<GameState>(GameState.MENU);
  const [cards, setCards] = useState<CardData[]>([]);
  const [player, setPlayer] = useState<PlayerStats>(INITIAL_PLAYER_STATS);
  const [floatingTexts, setFloatingTexts] = useState<FloatingText[]>([]);
  const [shopItems, setShopItems] = useState<ShopItem[]>([]);
  const [levelUpOptions, setLevelUpOptions] = useState<Perk[]>([]);
  const [showFloorIntro, setShowFloorIntro] = useState(false);
  
  // Effects State
  const [shake, setShake] = useState(false);
  const [flash, setFlash] = useState<'red' | 'white' | 'blue' | 'yellow' | 'purple' | 'green' | null>(null);

  const textIdCounter = useRef(0);
  const reachableIndices = useRef<Set<number>>(new Set());

  // Load High Score
  useEffect(() => {
    const savedScore = localStorage.getItem('mythic_highscore');
    if (savedScore) {
        setPlayer(p => ({ ...p, highScore: parseInt(savedScore, 10) }));
    }
  }, []);

  // -- Stats Calculation --
  const getDynamicPower = (currentStats: PlayerStats) => {
      let p = currentStats.power;
      
      // Perk: Might
      if (currentStats.perks.includes('might')) p += 1;
      
      // Warrior Passive: Rage
      if (currentStats.classId === 'warrior') {
          const missing = Math.max(0, currentStats.maxHp - currentStats.hp);
          p += Math.floor(missing / 20);
      }
      
      // Status: Weak
      if (currentStats.weak > 0) {
          p = Math.floor(p * 0.5);
      }
      return p;
  };
  
  const displayPlayer = { ...player, power: getDynamicPower(player) };

  // Helpers
  const getReachableIndices = (currentCards: CardData[]): Set<number> => {
    const reachable = new Set<number>();
    currentCards.forEach((card, index) => {
        if (card.isFlipped) {
            const row = Math.floor(index / GRID_COLS);
            const col = index % GRID_COLS;
            const neighbors = [
                { r: row - 1, c: col }, { r: row + 1, c: col },
                { r: row, c: col - 1 }, { r: row, c: col + 1 }
            ];
            neighbors.forEach(n => {
                if (n.r >= 0 && n.r < GRID_COLS && n.c >= 0 && n.c < GRID_COLS) {
                    const neighborIdx = n.r * GRID_COLS + n.c;
                    if (!currentCards[neighborIdx].isFlipped) {
                        reachable.add(neighborIdx);
                    }
                }
            });
        }
    });
    return reachable;
  };

  reachableIndices.current = getReachableIndices(cards);

  const hasRelic = (id: string) => player.relics.includes(id);
  const hasPerk = (id: string) => player.perks.includes(id);

  const getClassConfig = (): ClassConfig => {
      return CLASSES.find(c => c.id === player.classId) || CLASSES[0];
  };

  // Actions
  const selectClass = (classId: string) => {
      const cls = CLASSES.find(c => c.id === classId)!;
      setPlayer(prev => ({
          ...INITIAL_PLAYER_STATS, // Reset stats
          hp: cls.hp,
          maxHp: cls.hp,
          power: cls.power,
          shield: cls.shield,
          classId: cls.id,
          highScore: prev.highScore // Keep high score
      }));
      setGameState(GameState.PLAYING);
      loadFloor(1);
  };

  const loadFloor = (floorNum: number) => {
    const newCards = generateLevel(floorNum);
    setCards(newCards);
    
    setPlayer(prev => {
        let shield = prev.shield;
        if (hasRelic('stone')) shield += 15;
        if (hasPerk('fortress')) shield += 15;
        
        return { 
            ...prev, 
            floor: floorNum,
            shield: shield
        };
    });
    setGameState(GameState.PLAYING);
    setShowFloorIntro(true);
    setTimeout(() => setShowFloorIntro(false), 2000);
  };

  const useSkill = () => {
    if (player.skillCharge < 100) {
        triggerShake();
        return;
    }

    setPlayer(prev => ({ ...prev, skillCharge: 0 }));
    triggerFlash('purple');
    addFloatingText(window.innerWidth/2, window.innerHeight/2, "SKILL ACTIVATED!", "text-purple-400");

    switch (player.classId) {
        case 'warrior': // Fortify
            setPlayer(prev => ({ ...prev, shield: prev.shield + 25 }));
            addFloatingText(window.innerWidth/2, window.innerHeight/2 + 30, "+25 SHIELD", "text-blue-400");
            break;
        case 'paladin': // Holy Heal
            setPlayer(prev => ({ ...prev, hp: Math.min(prev.maxHp, prev.hp + 30) }));
            addFloatingText(window.innerWidth/2, window.innerHeight/2 + 30, "+30 HP", "text-green-400");
            break;
        case 'rogue': // Scout
            const unrevealedIdxs = cards
                .map((c, i) => ({ ...c, idx: i }))
                .filter(c => !c.isFlipped && !c.isRevealed)
                .map(c => c.idx);
            for (let i = unrevealedIdxs.length - 1; i > 0; i--) {
                const j = Math.floor(Math.random() * (i + 1));
                [unrevealedIdxs[i], unrevealedIdxs[j]] = [unrevealedIdxs[j], unrevealedIdxs[i]];
            }
            const toReveal = unrevealedIdxs.slice(0, 3);
            setCards(prev => prev.map((c, i) => toReveal.includes(i) ? { ...c, isRevealed: true } : c));
            addFloatingText(window.innerWidth/2, window.innerHeight/2 + 30, "AREA SCOUTED", "text-yellow-200");
            break;
    }
  };

  // -- XP & Level Up --
  const gainXp = (amount: number) => {
      setPlayer(prev => {
          let newXp = prev.xp + amount;
          let newLevel = prev.level;
          let newMaxXp = prev.maxXp;
          let didLevelUp = false;

          if (newXp >= newMaxXp) {
              newXp -= newMaxXp;
              newLevel += 1;
              newMaxXp = Math.floor(newMaxXp * 1.3);
              didLevelUp = true;
          }

          if (didLevelUp) {
              setTimeout(triggerLevelUp, 500); // Delay slightly for effect
          }

          return { ...prev, xp: newXp, level: newLevel, maxXp: newMaxXp };
      });
  };

  const triggerLevelUp = () => {
      // Pick 3 random perks
      const shuffled = [...PERKS].sort(() => 0.5 - Math.random());
      setLevelUpOptions(shuffled.slice(0, 3));
      setGameState(GameState.LEVEL_UP);
      triggerFlash('white');
  };

  const selectPerk = (perk: Perk) => {
      setPlayer(prev => {
          const newState = { ...prev, perks: [...prev.perks, perk.id] };
          
          // Immediate effects
          if (perk.id === 'thick_skin') {
              newState.maxHp += 15;
              newState.hp += 15;
          }
          if (perk.id === 'divine') {
              newState.hp = newState.maxHp;
              newState.poison = 0;
              newState.weak = 0;
          }
          return newState;
      });
      setGameState(GameState.PLAYING);
      addFloatingText(window.innerWidth/2, window.innerHeight/2, "LEVEL UP!", "text-yellow-200");
  };

  // -- Shop --
  const generateShop = () => {
      const items: ShopItem[] = [];
      const floorFactor = player.floor;
      
      items.push({
          id: 'potion_' + Date.now(),
          name: 'Big Potion',
          type: 'heal',
          value: 50,
          cost: 40 + (floorFactor * 5),
          icon: '💖',
          desc: 'Heal 50 HP'
      });

      items.push({
          id: 'key_' + Date.now(),
          name: 'Old Key',
          type: 'key',
          value: 1,
          cost: 30 + (floorFactor * 2),
          icon: '🗝️',
          desc: 'Open a chest'
      });

      if (Math.random() > 0.5) {
        items.push({
            id: 'atk_' + Date.now(),
            name: 'Sharpen',
            type: 'stat',
            value: 2,
            cost: 80 + (floorFactor * 10),
            icon: '🗡️',
            desc: '+2 ATK'
        });
      } else {
         items.push({
            id: 'shield_' + Date.now(),
            name: 'Plate Up',
            type: 'stat',
            value: 25,
            cost: 50 + (floorFactor * 5),
            icon: '🛡️',
            desc: '+25 Armor'
        });
      }

      const availableRelics = RELICS.filter(r => !player.relics.includes(r.id) && r.id !== 'sharp' && r.id !== 'vitality');
      if (availableRelics.length > 0) {
          const r = availableRelics[Math.floor(Math.random() * availableRelics.length)];
          items.push({
              id: r.id,
              name: r.name,
              type: 'relic',
              value: 0,
              cost: r.cost,
              icon: r.icon,
              desc: r.desc
          });
      } else {
           items.push({
              id: 'maxhp_' + Date.now(),
              name: 'Vitality',
              type: 'stat',
              value: 10,
              cost: 100,
              icon: '💗',
              desc: '+10 Max HP'
          });
      }

      setShopItems(items);
      setGameState(GameState.SHOP);
  };

  const buyItem = (item: ShopItem) => {
      if (item.isSold) return;
      if (player.gold < item.cost) {
          addFloatingText(window.innerWidth/2, window.innerHeight/2, "Need Gold!", "text-red-500");
          triggerShake();
          return;
      }

      setPlayer(prev => {
          const newState = { ...prev, gold: prev.gold - item.cost };
          
          if (item.type === 'heal') {
              newState.hp = Math.min(newState.maxHp, newState.hp + item.value);
          } else if (item.type === 'stat') {
              if (item.name === 'Sharpen') newState.power += item.value;
              else if (item.name === 'Plate Up') newState.shield += item.value;
              else if (item.name === 'Vitality') newState.maxHp += item.value;
          } else if (item.type === 'relic') {
              newState.relics = [...newState.relics, item.id];
          } else if (item.type === 'key') {
              newState.keys += 1;
          }
          return newState;
      });

      setShopItems(prev => prev.map(i => i.id === item.id ? { ...i, isSold: true } : i));
      triggerFlash('yellow');
      addFloatingText(window.innerWidth/2, window.innerHeight/2, "BOUGHT!", "text-yellow-400");
  };

  const addFloatingText = (x: number, y: number, text: string, color: string) => {
    const id = textIdCounter.current++;
    setFloatingTexts(prev => [...prev, { id, x, y, text, color }]);
    setTimeout(() => {
      setFloatingTexts(prev => prev.filter(ft => ft.id !== id));
    }, 1000);
  };

  const triggerShake = () => {
    setShake(true);
    setTimeout(() => setShake(false), 400);
  };

  const triggerFlash = (color: 'red' | 'white' | 'blue' | 'yellow' | 'purple' | 'green') => {
    setFlash(color);
    setTimeout(() => setFlash(null), 150);
  };

  const incrementCombo = (amount: number, x: number, y: number) => {
      setPlayer(prev => {
          const newCombo = prev.combo + amount;
          if (newCombo > 0 && newCombo % 5 === 0) {
               setTimeout(() => {
                   addFloatingText(x, y - 50, "COMBO BONUS! +1 MAX HP", "text-yellow-200");
                   setPlayer(p => ({ ...p, maxHp: p.maxHp + 1, hp: p.hp + 1 }));
               }, 200);
          }
          return { ...prev, combo: newCombo };
      });
  };

  const resetCombo = () => {
      if (player.combo > 1) {
          addFloatingText(window.innerWidth/2, window.innerHeight/2 - 50, "COMBO BROKEN", "text-gray-400");
      }
      setPlayer(prev => ({ ...prev, combo: 0 }));
  };

  // -- Interaction Handler --

  const handleCardClick = (card: CardData, event: React.MouseEvent<HTMLDivElement>) => {
    if (gameState !== GameState.PLAYING || card.isFlipped) return;

    const cardIndex = cards.findIndex(c => c.id === card.id);
    if (!reachableIndices.current.has(cardIndex)) {
        triggerShake();
        return;
    }

    const rect = (event.currentTarget as Element).getBoundingClientRect();
    const x = rect.left + rect.width / 2;
    const y = rect.top;

    if (card.type === CardType.CHEST && player.keys <= 0) {
        addFloatingText(x, y, "Locked! Need Key", "text-gray-400");
        triggerShake();
        return;
    }

    // Apply Poison
    if (player.poison > 0) {
        setPlayer(prev => {
            const dmg = Math.ceil(prev.maxHp * 0.05);
            addFloatingText(window.innerWidth/2, window.innerHeight - 100, `POISON -${dmg}`, "text-green-500");
            triggerFlash('green');
            const newHp = prev.hp - dmg;
            if (newHp <= 0) setTimeout(checkDeath, 100);
            return { ...prev, hp: newHp, poison: prev.poison - 1 };
        });
    }

    setCards(prev => prev.map(c => c.id === card.id ? { ...c, isFlipped: true } : c));
    
    setPlayer(prev => ({
        ...prev,
        skillCharge: Math.min(100, prev.skillCharge + (hasRelic('luck') ? 15 : 10))
    }));

    setTimeout(() => processCardEffect(card, x, y), 300);
  };

  const processCardEffect = (card: CardData, x: number, y: number) => {
    switch (card.type) {
      case CardType.MONSTER:
        handleCombat(card, x, y);
        break;
      case CardType.TRAP:
        handleTrap(card, x, y);
        break;
      case CardType.KEY:
        setPlayer(prev => ({ ...prev, keys: prev.keys + 1 }));
        addFloatingText(x, y, `Found Key`, 'text-yellow-100');
        incrementCombo(1, x, y);
        break;
      case CardType.CHEST:
        handleChest(card, x, y);
        break;
      case CardType.SHRINE:
        handleShrine(x, y);
        break;
      case CardType.WEAPON:
        setPlayer(prev => ({ ...prev, power: prev.power + card.value }));
        addFloatingText(x, y, `+${card.value} ATK`, 'text-yellow-400');
        incrementCombo(1, x, y);
        break;
      case CardType.SHIELD:
        setPlayer(prev => ({ ...prev, shield: prev.shield + card.value }));
        addFloatingText(x, y, `+${card.value} Armor`, 'text-blue-400');
        incrementCombo(1, x, y);
        break;
      case CardType.POTION:
        setPlayer(prev => {
            const heal = Math.min(card.value, prev.maxHp - prev.hp);
            return { ...prev, hp: prev.hp + heal };
        });
        addFloatingText(x, y, `+${card.value} HP`, 'text-green-400');
        incrementCombo(1, x, y);
        break;
      case CardType.TREASURE:
        let bonusGold = hasRelic('midas') ? Math.floor(card.value * 1.5) : card.value;
        if (hasPerk('greed')) bonusGold = Math.floor(bonusGold * 1.2);
        setPlayer(prev => ({ ...prev, gold: prev.gold + bonusGold, score: prev.score + bonusGold }));
        addFloatingText(x, y, `+${bonusGold} G`, 'text-yellow-300');
        triggerFlash('yellow');
        incrementCombo(1, x, y);
        break;
      case CardType.PORTAL:
        const nextFloor = player.floor + 1;
        addFloatingText(x, y, "LEVEL CLEARED", "text-blue-200");
        setTimeout(() => {
            if (nextFloor % 3 === 1 && nextFloor > 1) { 
                generateShop();
            } else {
                loadFloor(nextFloor);
            }
        }, 600);
        break;
    }
  };

  const handleChest = (card: CardData, x: number, y: number) => {
      setPlayer(prev => ({ ...prev, keys: prev.keys - 1 }));
      addFloatingText(x, y - 20, "Used Key", "text-gray-400");
      
      const rand = Math.random();
      if (rand < 0.25 || hasPerk('scavenger')) {
          const availableRelics = RELICS.filter(r => !player.relics.includes(r.id));
          if (availableRelics.length > 0) {
              const r = availableRelics[Math.floor(Math.random() * availableRelics.length)];
              setPlayer(prev => ({ ...prev, relics: [...prev.relics, r.id] }));
              addFloatingText(x, y, `FOUND ${r.name.toUpperCase()}!`, "text-purple-300");
          } else {
              const gold = card.value * 2;
              setPlayer(prev => ({ ...prev, gold: prev.gold + gold, score: prev.score + gold }));
              addFloatingText(x, y, `+${gold} GOLD`, "text-yellow-300");
          }
      } else {
           setPlayer(prev => ({ ...prev, gold: prev.gold + card.value, score: prev.score + card.value }));
           addFloatingText(x, y, `+${card.value} GOLD`, "text-yellow-300");
      }
      triggerFlash('yellow');
      incrementCombo(1, x, y);
  };

  const handleShrine = (x: number, y: number) => {
      const rand = Math.random();
      if (rand < 0.3) {
          setPlayer(prev => ({ ...prev, hp: Math.floor(prev.hp * 0.8) }));
          triggerFlash('red');
          addFloatingText(x, y, "CURSED! -20% HP", "text-purple-500");
          resetCombo();
      } else if (rand < 0.6) {
          const buff = Math.random() > 0.5 ? 'atk' : 'maxhp';
          if (buff === 'atk') {
               setPlayer(prev => ({ ...prev, power: prev.power + 2 }));
               addFloatingText(x, y, "BLESSED: +2 ATK", "text-blue-300");
          } else {
               setPlayer(prev => ({ ...prev, maxHp: prev.maxHp + 10, hp: prev.hp + 10 }));
               addFloatingText(x, y, "BLESSED: +10 MAX HP", "text-blue-300");
          }
      } else {
          setPlayer(prev => ({ ...prev, hp: prev.maxHp }));
          triggerFlash('white');
          addFloatingText(x, y, "DIVINE HEAL", "text-green-300");
      }
  };

  const handleTrap = (trap: CardData, x: number, y: number) => {
      setPlayer(prev => {
          let damage = trap.value;
          let newShield = prev.shield;
          
          if (newShield > 0) {
              const absorbed = Math.min(newShield, damage);
              newShield -= absorbed;
              damage -= absorbed;
          }
          
          if (damage > 0) {
            triggerFlash('red');
            addFloatingText(x, y, `-${damage} HP`, "text-red-500");
            resetCombo();
            return { ...prev, hp: prev.hp - damage, shield: newShield };
          } else {
             addFloatingText(x, y, `Blocked`, "text-blue-300");
             return { ...prev, shield: newShield };
          }
      });
      triggerShake();
      checkDeath();
  };

  const handleCombat = (monster: CardData, x: number, y: number) => {
    let effectivePower = getDynamicPower(player);
    const monsterPower = monster.value;

    // Perk: Executioner (Instant kill low power enemies)
    if (hasPerk('executioner') && monsterPower < 15) effectivePower = 9999;
    
    // Perk: Sharpness (Crit chance)
    if (hasPerk('sharpness') && Math.random() < 0.5) {
        effectivePower = Math.floor(effectivePower * 1.5);
        addFloatingText(x, y - 40, "CRIT!", "text-red-600 font-bold text-3xl");
    }

    if (effectivePower >= monsterPower) {
      // WIN
      let goldReward = Math.floor(monsterPower / 2) + 5;
      if (monster.isBoss) goldReward *= 5;
      if (hasRelic('midas')) goldReward = Math.floor(goldReward * 1.5);
      if (hasPerk('greed')) goldReward = Math.floor(goldReward * 1.2);

      // XP Gain
      const xpGain = monster.isBoss ? 20 : 5;
      gainXp(xpGain);
      
      setPlayer(prev => {
          let newHp = prev.hp;
          if (hasRelic('vampire')) newHp = Math.min(prev.maxHp, newHp + 3);
          if (prev.classId === 'paladin') newHp = Math.min(prev.maxHp, newHp + 2);
          if (hasPerk('leech')) newHp = Math.min(prev.maxHp, newHp + 1);
          
          const newWeak = Math.max(0, prev.weak - 1);
          return { ...prev, gold: prev.gold + goldReward, score: prev.score + (goldReward * 2), hp: newHp, weak: newWeak };
      });
      
      if (monster.affix === 'cursed') {
           setPlayer(prev => ({ ...prev, weak: prev.weak + 3 }));
           addFloatingText(x, y - 60, "CURSED! WEAKENED", "text-purple-500");
      }

      addFloatingText(x, y - 20, `+${goldReward} G`, 'text-yellow-300');
      addFloatingText(x, y - 10, `+${xpGain} XP`, 'text-cyan-300');

      incrementCombo(1, x, y);

    } else {
      // LOSE - Take Damage
      
      // Rogue / Survivor Perk Dodge
      const dodgeChance = player.classId === 'rogue' ? 0.2 : 0;
      // Note: We could add a 'survivor' perk here too if we had one
      
      if (Math.random() < dodgeChance) {
          addFloatingText(x, y, "DODGED!", "text-blue-400");
          incrementCombo(1, x, y);
          return;
      }

      let damage = monsterPower - effectivePower;
      if (monster.affix === 'sharp') damage = Math.floor(damage * 1.5);

      setPlayer(prev => {
          let remainingDmg = damage;
          let newShield = prev.shield;
          
          if (newShield > 0) {
              const absorbed = Math.min(newShield, remainingDmg);
              newShield -= absorbed;
              remainingDmg -= absorbed;
          }

          const newHp = prev.hp - remainingDmg;
          
          if (newShield !== prev.shield) triggerFlash('blue');
          else triggerFlash('red');

          if (remainingDmg > 0) {
              addFloatingText(x, y, `-${remainingDmg} HP`, "text-red-500");
              resetCombo();
              
              if (monster.affix === 'toxic') {
                  setTimeout(() => {
                      addFloatingText(x, y - 40, "POISONED!", "text-green-500");
                  }, 200);
                  return { ...prev, hp: newHp, shield: newShield, poison: prev.poison + 5 };
              }
          } else {
              addFloatingText(x, y, `Blocked`, "text-blue-300");
          }
          
          return { ...prev, hp: newHp, shield: newShield };
      });
      
      setPlayer(prev => ({...prev, weak: Math.max(0, prev.weak - 1)}));

      triggerShake();
      checkDeath();
    }
  };

  const checkDeath = () => {
      setTimeout(() => {
          setPlayer(current => {
              if (current.hp <= 0) {
                  const finalScore = current.score;
                  const bestScore = Math.max(finalScore, current.highScore);
                  localStorage.setItem('mythic_highscore', bestScore.toString());
                  setGameState(GameState.GAME_OVER);
                  return { ...current, highScore: bestScore };
              }
              return current;
          });
      }, 100);
  };

  const classConfig = getClassConfig();

  return (
    <div className={`h-screen w-screen flex flex-col items-center bg-gray-950 overflow-hidden relative font-sans ${shake ? 'animate-shake' : ''}`}>
      
      <div className="absolute inset-0 bg-[url('https://images.unsplash.com/photo-1605806616949-1e87b487bc2a?q=80&w=1000')] bg-cover bg-center opacity-10 pointer-events-none grayscale" />

      <FloatingTextLayer items={floatingTexts} />
      
      {flash && <div className={`fixed inset-0 z-40 pointer-events-none transition-opacity duration-150 
        ${flash === 'red' ? 'bg-red-600/40' : 
          flash === 'blue' ? 'bg-blue-500/30' : 
          flash === 'yellow' ? 'bg-yellow-400/30' : 
          flash === 'purple' ? 'bg-purple-500/30' :
          flash === 'green' ? 'bg-green-500/30' :
          'bg-white/50'}`} 
      />}

      {showFloorIntro && (
          <div className="fixed inset-0 z-50 bg-black flex items-center justify-center animate-fade-in pointer-events-none">
              <div className="text-center">
                  <h1 className="text-7xl font-art text-red-600 animate-pulse drop-shadow-[0_0_15px_rgba(220,38,38,0.8)]">FLOOR {player.floor}</h1>
                  <p className="text-gray-400 text-xl font-retro mt-4">Make your move...</p>
              </div>
          </div>
      )}

      {/* --- HUD --- */}
      {gameState !== GameState.MENU && gameState !== GameState.CLASS_SELECT && !showFloorIntro && (
      <div className="relative z-10 w-full max-w-md p-2 flex flex-col gap-1 mt-safe">
        <div className="flex justify-between items-center bg-gray-900/90 p-2 rounded-xl border border-gray-700 shadow-xl backdrop-blur-sm">
           <div className="flex gap-4">
               <div>
                  <span className="text-[10px] text-gray-400 uppercase tracking-widest block font-retro">LVL {player.level}</span>
                  <div className="w-12 h-1 bg-gray-700 rounded-full overflow-hidden">
                      <div className="h-full bg-cyan-400 transition-all" style={{ width: `${(player.xp / player.maxXp) * 100}%` }}></div>
                  </div>
               </div>
               <div>
                  <span className="text-[10px] text-gray-400 uppercase tracking-widest block font-retro">Gold</span>
                  <span className="text-xl font-num text-yellow-400 leading-none">{player.gold}</span>
               </div>
               <div>
                  <span className="text-[10px] text-gray-400 uppercase tracking-widest block font-retro">Score</span>
                  <span className="text-xl font-num text-white leading-none">{player.score}</span>
               </div>
           </div>
           
           <div className="flex items-center gap-2">
               {player.combo > 1 && <div className="text-orange-400 font-num text-xl animate-pulse mr-2">{player.combo}x COMBO</div>}
               <div className="flex gap-1">
                   {player.keys > 0 && (
                       <div className="px-2 bg-slate-800 rounded border border-slate-600 flex items-center gap-1">
                           <span>🗝️</span><span className="font-bold">{player.keys}</span>
                       </div>
                   )}
                   {player.relics.map(rId => (
                       <div key={rId} className="w-8 h-8 bg-black/50 rounded-full flex items-center justify-center text-lg border border-gray-600" title={RELICS.find(r=>r.id===rId)?.desc}>
                           {RELICS.find(r=>r.id===rId)?.icon}
                       </div>
                   ))}
               </div>
           </div>
        </div>

        {/* Status Bar */}
        <div className="grid grid-cols-[1.2fr_0.8fr] gap-2">
            {/* HP & Shield */}
            <div className="bg-gray-800/80 p-2 rounded-lg border border-gray-700 relative overflow-hidden">
                <div className="flex justify-between text-xs mb-1 font-retro uppercase relative z-10">
                    <span className="text-red-300">HP</span>
                    <span>{player.hp}/{player.maxHp}</span>
                </div>
                <div className="h-3 bg-gray-950 rounded-sm border border-gray-700 overflow-hidden relative mb-1 z-10">
                    <div className="h-full bg-red-700 transition-all duration-300" style={{ width: `${(Math.max(0, player.hp) / player.maxHp) * 100}%` }} />
                </div>
                {player.shield > 0 && (
                    <div className="flex items-center gap-1 mt-1 z-10 relative">
                         <div className="h-1.5 flex-1 bg-gray-950 rounded-sm overflow-hidden">
                             <div className="h-full bg-blue-500 w-full animate-pulse" />
                         </div>
                         <span className="text-xs text-blue-300 font-bold">{player.shield}</span>
                    </div>
                )}
                {/* Status Icons Overlay */}
                <div className="absolute right-1 top-1 flex flex-col gap-1 items-end opacity-90">
                    {player.poison > 0 && <span className="text-xs bg-black/60 px-1 rounded text-green-400 border border-green-800 animate-pulse">☠️ {player.poison}</span>}
                </div>
            </div>
            
            {/* Power & Skill */}
            <div className="flex flex-col gap-1">
                <div className="bg-gray-800/80 p-1 px-3 rounded-lg border border-gray-700 flex items-center justify-between relative overflow-hidden">
                     <span className="text-xs text-yellow-200 font-bold z-10">ATK</span>
                     <div className="flex items-baseline gap-1 z-10">
                         <span className={`text-xl font-num ${player.weak > 0 ? 'text-gray-400' : 'text-yellow-400'}`}>⚔️{displayPlayer.power}</span>
                         {displayPlayer.power > player.power && <span className="text-[10px] text-green-400 font-bold">(+{displayPlayer.power - player.power})</span>}
                         {displayPlayer.power < player.power && <span className="text-[10px] text-red-400 font-bold">(-{player.power - displayPlayer.power})</span>}
                     </div>
                     {player.weak > 0 && <div className="absolute inset-0 bg-black/60 flex items-center justify-center text-xs text-gray-300 font-bold pointer-events-none">WEAK ({player.weak})</div>}
                </div>
                
                <button 
                    onClick={useSkill}
                    disabled={player.skillCharge < 100}
                    className={`flex-1 rounded-lg border flex items-center justify-center text-xs font-bold transition-all
                        ${player.skillCharge >= 100 
                            ? 'bg-purple-900 border-purple-400 text-purple-100 hover:bg-purple-800 animate-pulse cursor-pointer shadow-[0_0_10px_rgba(168,85,247,0.5)]' 
                            : 'bg-gray-900 border-gray-700 text-gray-500 cursor-not-allowed'}
                    `}
                >
                    {player.skillCharge >= 100 ? classConfig.skillName.toUpperCase() : `${Math.floor(player.skillCharge)}%`}
                </button>
            </div>
        </div>
      </div>
      )}

      {/* --- Game Area --- */}
      <div className="relative z-10 flex-1 w-full max-w-md p-2 flex flex-col justify-center items-center">
        
        {/* MENU */}
        {gameState === GameState.MENU && (
          <div className="text-center space-y-6 animate-float p-8 bg-black/60 rounded-2xl border border-red-900/50 backdrop-blur-md shadow-2xl w-full">
            <h1 className="text-6xl md:text-7xl font-art text-transparent bg-clip-text bg-gradient-to-b from-red-500 to-red-900 drop-shadow-[2px_2px_0px_rgba(0,0,0,1)]">
                Mythic<br/>Dungeon
            </h1>
            <div className="text-yellow-500 font-retro tracking-widest text-lg">HIGH SCORE: {player.highScore}</div>
            <button 
              onClick={() => setGameState(GameState.CLASS_SELECT)}
              className="w-full bg-red-900/80 text-white font-bold text-2xl py-4 rounded-lg border-2 border-red-600 hover:bg-red-700 hover:scale-105 transition-all shadow-[0_0_20px_rgba(220,38,38,0.4)]"
            >
              ENTER DUNGEON
            </button>
          </div>
        )}

        {/* CLASS SELECT */}
        {gameState === GameState.CLASS_SELECT && (
             <div className="w-full space-y-4 animate-float">
                 <h2 className="text-center text-3xl font-art text-white mb-2">Select Class</h2>
                 {CLASSES.map(cls => (
                     <button 
                        key={cls.id}
                        onClick={() => selectClass(cls.id)}
                        className="w-full bg-gray-900/90 hover:bg-gray-800 border-2 border-gray-700 hover:border-yellow-500 p-4 rounded-xl flex items-center gap-4 transition-all group text-left shadow-lg relative overflow-hidden"
                     >
                         <div className="text-4xl bg-black/50 p-3 rounded-lg group-hover:scale-110 transition-transform z-10">{cls.icon}</div>
                         <div className="z-10 flex-1">
                             <div className="flex justify-between items-center">
                                 <div className="font-bold text-xl text-yellow-100 font-art tracking-wide">{cls.name}</div>
                                 <div className="text-xs text-purple-300 font-bold border border-purple-500/50 px-2 py-0.5 rounded bg-purple-900/20">{cls.skillName}</div>
                             </div>
                             <div className="text-xs text-gray-400 my-1">{cls.desc}</div>
                             <div className="text-[10px] text-yellow-500/80 italic mb-2">
                                Passive: <span className="font-bold text-yellow-500">{cls.passiveName}</span> - {cls.passiveDesc}
                             </div>
                             <div className="grid grid-cols-3 gap-2 text-[10px] text-gray-500 font-retro">
                                 <span>HP: {cls.hp}</span>
                                 <span>ATK: {cls.power}</span>
                                 <span>DEF: {cls.shield}</span>
                             </div>
                         </div>
                     </button>
                 ))}
                 <button onClick={() => setGameState(GameState.MENU)} className="w-full py-2 text-gray-500 hover:text-white">Back</button>
             </div>
        )}

        {/* PLAYING */}
        {gameState === GameState.PLAYING && (
          <div className="grid grid-cols-4 gap-2 w-full max-w-[400px]">
            {cards.map((card, index) => (
               <div key={card.id} onClick={(e) => handleCardClick(card, e)} className="w-full">
                  <Card 
                    card={card} 
                    onClick={() => {}}
                    playerPower={displayPlayer.power}
                    isReachable={reachableIndices.current.has(index)}
                  />
               </div>
            ))}
          </div>
        )}

        {/* LEVEL UP */}
        {gameState === GameState.LEVEL_UP && (
            <div className="absolute inset-0 z-50 flex flex-col items-center justify-center p-4 bg-black/90 backdrop-blur-md animate-fade-in">
                <h2 className="text-5xl font-art text-yellow-400 mb-2 drop-shadow-[0_0_10px_rgba(250,204,21,0.5)]">LEVEL UP!</h2>
                <p className="text-gray-300 mb-6 text-lg font-retro">Choose your boon...</p>
                <div className="grid grid-cols-1 gap-4 w-full max-w-sm">
                    {levelUpOptions.map(perk => (
                        <button
                            key={perk.id}
                            onClick={() => selectPerk(perk)}
                            className={`p-4 rounded-xl border-2 flex items-center gap-4 transition-all hover:scale-105 hover:bg-gray-800
                                ${perk.rarity === 'common' ? 'border-gray-500 bg-gray-900' : 
                                  perk.rarity === 'rare' ? 'border-blue-500 bg-gray-900 shadow-blue-500/20 shadow-lg' : 
                                  perk.rarity === 'epic' ? 'border-purple-500 bg-gray-900 shadow-purple-500/20 shadow-lg' : 
                                  'border-yellow-500 bg-gray-900 shadow-yellow-500/20 shadow-lg'}
                            `}
                        >
                            <div className="text-4xl">{perk.icon}</div>
                            <div className="text-left flex-1">
                                <div className="font-bold text-xl text-white font-art">{perk.name}</div>
                                <div className="text-sm text-gray-400">{perk.desc}</div>
                            </div>
                        </button>
                    ))}
                </div>
            </div>
        )}

        {/* SHOP */}
        {gameState === GameState.SHOP && (
             <div className="w-full animate-float">
                 <h2 className="text-center text-4xl font-art text-yellow-500 mb-6 drop-shadow-md">Merchant</h2>
                 <div className="grid grid-cols-2 gap-3 mb-6">
                     {shopItems.map(item => (
                         <div 
                            key={item.id}
                            onClick={() => buyItem(item)}
                            className={`p-3 rounded-xl border-2 flex flex-col items-center text-center transition-all relative overflow-hidden
                                ${item.isSold 
                                    ? 'bg-gray-900 border-gray-800 opacity-50 grayscale cursor-default' 
                                    : 'bg-gray-900/90 border-yellow-700 hover:border-yellow-400 cursor-pointer hover:bg-gray-800 active:scale-95'}
                            `}
                         >
                             {item.isSold && (
                                 <div className="absolute inset-0 flex items-center justify-center z-10">
                                     <span className="text-red-600 font-bold text-2xl -rotate-12 border-2 border-red-600 p-1 px-4 bg-black/50">SOLD</span>
                                 </div>
                             )}
                             <div className="text-3xl mb-1">{item.icon}</div>
                             <div className="font-bold text-sm text-yellow-100">{item.name}</div>
                             <div className="text-xs text-gray-400 mb-2">{item.desc}</div>
                             <div className={`text-sm font-bold px-2 py-0.5 rounded ${player.gold >= item.cost ? 'text-yellow-400 bg-black/40' : 'text-red-400 bg-black/40'}`}>
                                 {item.cost} G
                             </div>
                         </div>
                     ))}
                 </div>
                 <button 
                    onClick={() => loadFloor(player.floor)}
                    className="w-full py-4 bg-gray-800 text-gray-300 font-bold rounded-xl border border-gray-600 hover:bg-gray-700"
                 >
                     Leave Shop
                 </button>
             </div>
        )}

        {/* GAME OVER */}
        {gameState === GameState.GAME_OVER && (
            <div className="text-center animate-float w-full max-w-sm bg-black/80 p-6 rounded-2xl border border-red-900 shadow-2xl">
                <h2 className="text-5xl font-art text-red-600 mb-2">YOU DIED</h2>
                <div className="text-xl text-gray-300 mb-6">Floor {player.floor} Reached</div>
                
                <div className="grid grid-cols-2 gap-4 mb-8 bg-gray-900 p-4 rounded-xl">
                    <div>
                        <div className="text-xs text-gray-500 uppercase tracking-widest">Score</div>
                        <div className="text-2xl font-num text-white">{player.score}</div>
                    </div>
                    <div>
                        <div className="text-xs text-gray-500 uppercase tracking-widest">Best</div>
                        <div className="text-2xl font-num text-yellow-400">{player.highScore}</div>
                    </div>
                </div>

                <div className="mb-6 flex justify-center gap-2">
                    {player.perks.map((pid, idx) => {
                        const p = PERKS.find(x => x.id === pid);
                        return p ? <div key={idx} className="text-2xl" title={p.name}>{p.icon}</div> : null;
                    })}
                </div>

                <button 
                    onClick={() => setGameState(GameState.MENU)}
                    className="w-full bg-white text-black font-bold py-3 rounded-lg hover:bg-gray-200 transition-colors"
                >
                    Try Again
                </button>
            </div>
        )}

      </div>
    </div>
  );
};

export default App;
