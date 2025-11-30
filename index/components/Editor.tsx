import React, { useState, useRef } from 'react';
import { motion } from 'framer-motion';
import { X, Lock, Globe, Image as ImageIcon, Trash2 } from 'lucide-react';
import { DiaryEntry } from '../types';

interface EditorProps {
  onClose: () => void;
  onSave: (content: string, isPrivate: boolean, image?: string) => void;
}

export const Editor: React.FC<EditorProps> = ({ onClose, onSave }) => {
  const [content, setContent] = useState('');
  const [isPrivate, setIsPrivate] = useState(true);
  const [image, setImage] = useState<string | null>(null);
  const fileInputRef = useRef<HTMLInputElement>(null);

  const handleImageUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setImage(reader.result as string);
      };
      reader.readAsDataURL(file);
    }
  };

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0 }}
      className="fixed inset-0 z-[60] flex items-center justify-center bg-black/50 backdrop-blur-sm"
    >
      <div className="absolute inset-0" onClick={onClose} />
      
      <motion.div
        initial={{ y: 100, scale: 0.9 }}
        animate={{ y: 0, scale: 1 }}
        exit={{ y: 100, scale: 0.9, opacity: 0 }}
        className="relative w-full max-w-lg bg-card rounded-2xl shadow-2xl overflow-hidden flex flex-col max-h-[85vh]"
      >
        {/* Header Area */}
        <div className="p-6 pb-2 flex justify-between items-center">
            <div className="flex flex-col">
                <span className="font-serif text-ink font-bold text-xl">新记忆</span>
                <span className="text-xs text-ink-light uppercase tracking-widest">
                    {new Date().toLocaleDateString('zh-CN', { year: 'numeric', month: 'long', day: 'numeric' })}
                </span>
            </div>
            <button onClick={onClose} className="p-2 hover:bg-ink/5 rounded-full text-ink">
                <X size={20} />
            </button>
        </div>

        {/* Text Area (The "Paper") */}
        <div className="flex-1 p-6 pt-2 overflow-y-auto">
            {/* Image Preview */}
            {image && (
              <div className="relative mb-4 group">
                <img src={image} alt="Preview" className="w-full h-40 object-cover rounded-lg shadow-sm" />
                <button 
                  onClick={() => setImage(null)}
                  className="absolute top-2 right-2 p-1.5 bg-black/50 text-white rounded-full opacity-0 group-hover:opacity-100 transition-opacity"
                >
                  <Trash2 size={16} />
                </button>
              </div>
            )}

            <textarea
                autoFocus
                value={content}
                onChange={(e) => setContent(e.target.value)}
                placeholder="今天有什么值得记录的？"
                className="w-full min-h-[200px] bg-transparent resize-none outline-none font-serif text-ink text-lg placeholder:text-ink/30 leading-relaxed"
                style={{
                     backgroundImage: 'linear-gradient(#4A4238 1px, transparent 1px)', 
                     backgroundSize: '100% 32px',
                     lineHeight: '32px'
                }}
            />
        </div>

        {/* Bottom Bar: Tools & Save */}
        <div className="p-6 pt-0 flex justify-between items-center border-t border-ink/5 mt-2 bg-card">
            
            <div className="flex gap-4 items-center pt-4">
                 {/* Privacy Slider */}
                <div 
                    onClick={() => setIsPrivate(!isPrivate)}
                    className={`relative w-16 h-8 rounded-full cursor-pointer transition-colors duration-300 flex items-center px-1 ${isPrivate ? 'bg-[#2D3138]' : 'bg-indigo-900'}`}
                    title={isPrivate ? "私密" : "公开"}
                >
                    <motion.div
                        className="w-6 h-6 bg-white rounded-full shadow-sm flex items-center justify-center"
                        animate={{ x: isPrivate ? 0 : 32 }}
                        transition={{ type: "spring", stiffness: 500, damping: 30 }}
                    >
                        {isPrivate ? <Lock size={12} className="text-ink" /> : <Globe size={12} className="text-blue-600" />}
                    </motion.div>
                </div>

                {/* Image Upload Button */}
                <button 
                  onClick={() => fileInputRef.current?.click()}
                  className="p-2 hover:bg-ink/10 rounded-full text-ink/70 hover:text-ink transition-colors"
                  title="添加照片"
                >
                  <ImageIcon size={24} />
                </button>
                <input 
                  type="file" 
                  ref={fileInputRef} 
                  className="hidden" 
                  accept="image/*" 
                  onChange={handleImageUpload}
                />
            </div>

            {/* Save Button */}
            <button
                onClick={() => onSave(content, isPrivate, image || undefined)}
                disabled={!content.trim()}
                className="mt-4 px-6 py-2 bg-ink text-card font-serif font-bold rounded-full hover:bg-ink/90 disabled:opacity-50 disabled:cursor-not-allowed transition-all"
            >
                发牌
            </button>
        </div>
      </motion.div>
    </motion.div>
  );
};