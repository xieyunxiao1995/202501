
import React from 'react';
import { Page } from '../types';
import { Layers, Sparkles, Globe, Plus, Settings } from 'lucide-react';
import { motion } from 'framer-motion';

interface BottomNavProps {
  activePage: Page;
  onNavigate: (page: Page) => void;
  onOpenEditor: () => void;
}

export const BottomNav: React.FC<BottomNavProps> = ({ activePage, onNavigate, onOpenEditor }) => {
  const navItems = [
    { id: 'HOME', icon: Layers, label: '记忆' },
    { id: 'COMPANION', icon: Sparkles, label: '伴侣' },
    { id: 'SQUARE', icon: Globe, label: '广场' },
    { id: 'SETTINGS', icon: Settings, label: '设置' },
  ];

  return (
    <div className="fixed bottom-8 left-1/2 -translate-x-1/2 z-50">
      <div className="relative bg-white/10 backdrop-blur-xl border border-white/40 shadow-2xl rounded-full px-6 py-3 flex items-center gap-2 md:gap-6">
        
        {/* Nav Items Left */}
        {navItems.slice(0, 2).map((item) => (
           <NavButton 
             key={item.id}
             isActive={activePage === item.id}
             onClick={() => onNavigate(item.id as Page)}
             icon={item.icon}
             label={item.label}
           />
        ))}

        {/* Central Add Button */}
        <div className="mx-2 relative group">
            <button 
                onClick={onOpenEditor}
                className="w-14 h-14 bg-ink text-card rounded-full shadow-lg flex items-center justify-center transform transition-transform group-hover:scale-110 active:scale-95"
            >
                <Plus size={28} />
            </button>
            {/* Glow effect */}
            <div className="absolute inset-0 bg-ink rounded-full blur-lg opacity-20 group-hover:opacity-40 transition-opacity pointer-events-none -z-10"></div>
        </div>

        {/* Nav Items Right */}
        {navItems.slice(2, 4).map((item) => (
           <NavButton 
             key={item.id}
             isActive={activePage === item.id}
             onClick={() => onNavigate(item.id as Page)}
             icon={item.icon}
             label={item.label}
           />
        ))}

      </div>
    </div>
  );
};

interface NavButtonProps {
    isActive: boolean;
    onClick: () => void;
    icon: any;
    label: string;
}

const NavButton: React.FC<NavButtonProps> = ({ isActive, onClick, icon: Icon, label }) => (
    <button 
        onClick={onClick}
        className={`relative p-3 rounded-full transition-all duration-300 flex flex-col items-center justify-center w-12 h-12 ${isActive ? 'text-ink' : 'text-ink/40 hover:text-ink/70'}`}
    >
        <Icon size={24} strokeWidth={isActive ? 2.5 : 2} />
        
        {/* Active Dot Indicator */}
        {isActive && (
            <motion.div 
                layoutId="nav-dot"
                className="absolute -bottom-1 w-1 h-1 bg-ink rounded-full"
                transition={{ type: "spring", stiffness: 500, damping: 30 }}
            />
        )}
    </button>
);
