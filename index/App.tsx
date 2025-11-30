
import React, { useState } from 'react';
import { MemoryTable } from './components/MemoryTable';
import { FanView } from './components/FanView';
import { StackDetail } from './components/StackDetail';
import { BottomNav } from './components/BottomNav';
import { Companion } from './components/Companion';
import { Square } from './components/Square';
import { Editor } from './components/Editor';
import { Settings } from './components/Settings';
import { INITIAL_STACKS } from './constants';
import { CardStack, DiaryEntry, Page } from './types';
import { analyzeDiaryEntry } from './services/geminiService';
import { AnimatePresence } from 'framer-motion';

const App: React.FC = () => {
  const [stacks, setStacks] = useState<CardStack[]>(INITIAL_STACKS);
  const [activePage, setActivePage] = useState<Page>('HOME');
  const [viewMode, setViewMode] = useState<'TABLE' | 'FAN'>('TABLE');
  const [openStackId, setOpenStackId] = useState<string | null>(null);
  const [isEditorOpen, setIsEditorOpen] = useState(false);

  // Analyze Entry Handler
  const handleRequestAnalysis = async (entry: DiaryEntry) => {
      const result = await analyzeDiaryEntry(entry);
      setStacks(currentStacks => {
          return currentStacks.map(stack => ({
              ...stack,
              cards: stack.cards.map(card => {
                  if (card.id === entry.id) {
                      return { ...card, aiInsight: result.insight, aiTags: result.tags };
                  }
                  return card;
              })
          }));
      });
  };

  const handleSaveEntry = (content: string, isPrivate: boolean, image?: string) => {
    const newEntry: DiaryEntry = {
        id: Date.now().toString(),
        date: new Date().toISOString(),
        content,
        image,
        mood: 'calm', // Default mood, could be analyzed
        location: '我的书桌'
    };

    const newStack: CardStack = {
        id: `stack-${newEntry.id}`,
        cards: [newEntry],
        zIndex: stacks.length + 1,
        position: { x: 0, y: 0 }
    };

    setStacks([...stacks, newStack]);
    setIsEditorOpen(false);
    setActivePage('HOME');
  };

  const activeOpenStack = openStackId ? stacks.find(s => s.id === openStackId) : null;

  return (
    <main className="w-screen h-screen overflow-hidden bg-table font-sans text-ink relative selection:bg-ink/10 flex flex-col">
      
      {/* Page Content */}
      <div className="flex-1 relative w-full overflow-hidden">
        <AnimatePresence mode="wait">
            {activePage === 'HOME' && viewMode === 'TABLE' && (
                <MemoryTable 
                    key="home-table"
                    stacks={stacks} 
                    onStackUpdate={setStacks}
                    onOpenStack={setOpenStackId}
                    onRequestAnalysis={handleRequestAnalysis}
                />
            )}
            {activePage === 'HOME' && viewMode === 'FAN' && (
                <FanView 
                    key="home-fan"
                    stacks={stacks} 
                    onClose={() => setViewMode('TABLE')} 
                    onSelectStack={(id) => {
                        const stack = stacks.find(s => s.id === id);
                        if (stack && stack.cards.length > 1) {
                            setOpenStackId(id);
                        } else {
                            setViewMode('TABLE');
                        }
                    }}
                />
            )}
            {activePage === 'COMPANION' && (
                <Companion key="companion" />
            )}
            {activePage === 'SQUARE' && (
                <Square key="square" />
            )}
            {activePage === 'SETTINGS' && (
                <Settings key="settings" />
            )}
        </AnimatePresence>
      </div>

      {/* Navigation Layer */}
      <BottomNav 
        activePage={activePage} 
        onNavigate={(page) => {
            setActivePage(page);
            if(page === 'HOME') setViewMode('TABLE');
        }}
        onOpenEditor={() => setIsEditorOpen(true)}
      />

      {/* Editor Overlay */}
      <AnimatePresence>
        {isEditorOpen && (
            <Editor 
                onClose={() => setIsEditorOpen(false)} 
                onSave={handleSaveEntry}
            />
        )}
      </AnimatePresence>

      {/* Detail Overlay */}
      <AnimatePresence>
          {activeOpenStack && (
              <StackDetail 
                  stack={activeOpenStack} 
                  onClose={() => setOpenStackId(null)}
                  onRequestAnalysis={handleRequestAnalysis}
              />
          )}
      </AnimatePresence>

    </main>
  );
};

export default App;
