
import React, { useState } from 'react';
import { motion } from 'framer-motion';
import { INITIAL_SQUARE_POSTS } from '../constants';
import { Heart, Maximize2 } from 'lucide-react';

export const Square: React.FC = () => {
  const [posts, setPosts] = useState(INITIAL_SQUARE_POSTS);

  const handleLike = (id: string) => {
    setPosts(posts.map(post => {
        if (post.id === id) {
            return { ...post, isLiked: !post.isLiked, likes: post.isLiked ? post.likes - 1 : post.likes + 1 };
        }
        return post;
    }));
  };

  return (
    <div className="w-full h-full overflow-y-auto hide-scrollbar pt-20 pb-32 px-4 md:px-10">
        <div className="max-w-6xl mx-auto columns-2 md:columns-3 lg:columns-4 gap-6 space-y-6">
            {posts.map((post, i) => (
                <motion.div
                    key={post.id}
                    initial={{ opacity: 0, y: 50, rotate: 0 }}
                    animate={{ opacity: 1, y: 0, rotate: post.angle }}
                    transition={{ delay: i * 0.1 }}
                    className="break-inside-avoid relative group"
                >
                    <div className="bg-white p-3 pb-8 shadow-md rounded-sm transform transition-transform duration-300 hover:scale-105 hover:z-10 hover:shadow-2xl hover:rotate-0 border border-black/5">
                        {/* Image/Color Area */}
                        <motion.div 
                            className="w-full aspect-square mb-4 bg-gray-100 relative overflow-hidden shadow-inner"
                            style={{ backgroundColor: post.image ? 'transparent' : post.color }}
                            whileTap={{ scale: 0.98 }}
                        >
                            {post.image ? (
                                <img src={post.image} alt="Memory" className="w-full h-full object-cover" />
                            ) : (
                                <div className="absolute inset-0 bg-noise opacity-20" />
                            )}
                            
                            {/* "Hug" Flash Effect */}
                            {post.isLiked && (
                                <motion.div 
                                    initial={{ opacity: 0 }} 
                                    animate={{ opacity: [0, 0.5, 0] }}
                                    className="absolute inset-0 bg-white z-20"
                                />
                            )}
                        </motion.div>

                        {/* Text Area */}
                        <div className="px-1">
                            <p className="font-hand text-ink text-sm mb-3 leading-tight">{post.content}</p>
                            <div className="flex justify-between items-center text-xs text-ink/50 font-sans uppercase tracking-wider">
                                <span>{post.author}</span>
                                <button 
                                    onClick={() => handleLike(post.id)}
                                    className="flex items-center gap-1 hover:text-red-500 transition-colors group/btn"
                                >
                                    <Heart 
                                        size={14} 
                                        fill={post.isLiked ? "#EF4444" : "none"} 
                                        className={`transition-transform duration-200 ${post.isLiked ? "text-red-500 scale-110" : "group-hover/btn:scale-110"}`} 
                                    />
                                    <span>{post.likes}</span>
                                </button>
                            </div>
                        </div>
                    </div>
                </motion.div>
            ))}
        </div>
        
        {/* Empty State Text if needed */}
        {posts.length === 0 && (
             <div className="flex justify-center items-center h-64 text-ink/40 font-serif italic">
                 广场上静悄悄的...
             </div>
        )}
    </div>
  );
};
