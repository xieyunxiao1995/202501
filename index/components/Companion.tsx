import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { INITIAL_CHAT } from '../constants';
import { Send } from 'lucide-react';

export const Companion: React.FC = () => {
  const [messages, setMessages] = useState(INITIAL_CHAT);
  const [input, setInput] = useState('');

  const handleSend = () => {
      if(!input.trim()) return;
      const userMsg = { id: Date.now().toString(), sender: 'USER', text: input };
      setMessages([...messages, userMsg as any]);
      setInput('');

      // Mock AI Reply
      setTimeout(() => {
          setMessages(prev => [...prev, { 
              id: (Date.now()+1).toString(), 
              sender: 'AI', 
              text: "我听到了。关于这种感觉，能再多和我说说吗？" 
          } as any]);
      }, 1500);
  };

  return (
    <div className="w-full h-full relative overflow-hidden flex flex-col items-center">
      {/* Background Breathing Aura */}
      <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
          <motion.div 
             animate={{ scale: [1, 1.2, 1], opacity: [0.3, 0.5, 0.3] }}
             transition={{ duration: 8, repeat: Infinity, ease: "easeInOut" }}
             className="w-[500px] h-[500px] rounded-full bg-gradient-radial from-white/40 to-transparent blur-3xl"
          />
      </div>

      {/* Chat Area */}
      <div className="flex-1 w-full max-w-2xl px-6 py-20 flex flex-col gap-8 overflow-y-auto hide-scrollbar z-10">
          {messages.map((msg) => (
              <motion.div 
                key={msg.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                className={`flex flex-col ${msg.sender === 'USER' ? 'items-end' : 'items-start'}`}
              >
                  {msg.sender === 'AI' ? (
                      <div className="max-w-[80%] relative">
                          <div className="absolute inset-0 bg-white/40 blur-xl rounded-full opacity-50"></div>
                          <p className="relative text-ink font-serif text-xl leading-relaxed drop-shadow-sm">
                             {msg.text}
                          </p>
                      </div>
                  ) : (
                      <div className="max-w-[80%]">
                          <p className="text-ink font-sans text-base pb-1 border-b border-ink/20 inline-block">
                             {msg.text}
                          </p>
                      </div>
                  )}
              </motion.div>
          ))}
      </div>

      {/* Input Area */}
      <div className="w-full max-w-2xl px-6 pb-28 z-20">
          <div className="relative flex items-center">
              <input
                type="text"
                value={input}
                onChange={(e) => setInput(e.target.value)}
                onKeyDown={(e) => e.key === 'Enter' && handleSend()}
                placeholder="对着虚空，说点什么..."
                className="w-full bg-white/20 backdrop-blur-md rounded-full px-6 py-4 pr-12 text-ink placeholder:text-ink/40 outline-none border border-white/30 focus:bg-white/30 transition-colors"
              />
              <button 
                onClick={handleSend}
                className="absolute right-2 p-2 bg-ink text-table rounded-full hover:scale-105 transition-transform"
              >
                  <Send size={18} />
              </button>
          </div>
      </div>
    </div>
  );
};