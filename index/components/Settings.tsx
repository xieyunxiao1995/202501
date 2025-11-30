
import React from 'react';
import { motion } from 'framer-motion';
import { Settings as SettingsIcon, Bell, Moon, Database, HelpCircle, LogOut, ChevronRight, User } from 'lucide-react';

export const Settings: React.FC = () => {
  const menuItems = [
    { icon: <User size={20} />, label: '个人资料', value: 'MindFlow 用户' },
    { icon: <Moon size={20} />, label: '外观模式', value: '暖调书房 (默认)' },
    { icon: <Bell size={20} />, label: '通知提醒', value: '每天 21:00' },
    { icon: <Database size={20} />, label: '数据导出', value: '' },
    { icon: <HelpCircle size={20} />, label: '关于心屿', value: 'v2.1.0' },
  ];

  return (
    <div className="w-full h-full pt-24 px-4 flex justify-center overflow-y-auto hide-scrollbar">
      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="w-full max-w-2xl"
      >
        {/* Header - Looks like a clipboard title */}
        <div className="text-center mb-10">
            <h1 className="font-serif text-3xl text-ink font-bold mb-2">设置清单</h1>
            <div className="h-1 w-16 bg-ink/10 mx-auto rounded-full"></div>
        </div>

        {/* Paper Container */}
        <div className="bg-card relative rounded-sm shadow-xl border border-white/60 p-8 min-h-[500px] transform rotate-1">
             {/* Paper Texture */}
             <div className="absolute inset-0 pointer-events-none opacity-20"
                style={{ backgroundImage: 'linear-gradient(#4A4238 1px, transparent 1px)', backgroundSize: '100% 32px' }}>
             </div>
             
             {/* Content */}
             <div className="relative z-10 space-y-2">
                 {menuItems.map((item, index) => (
                     <motion.div 
                        key={item.label}
                        whileHover={{ x: 4, backgroundColor: 'rgba(74, 66, 56, 0.03)' }}
                        className="flex items-center justify-between p-4 rounded-lg cursor-pointer group transition-all"
                     >
                         <div className="flex items-center gap-4 text-ink">
                             <div className="p-2 bg-ink/5 rounded-full group-hover:bg-ink/10 transition-colors">
                                {item.icon}
                             </div>
                             <span className="font-serif text-lg font-medium">{item.label}</span>
                         </div>
                         <div className="flex items-center gap-2 text-ink-light">
                             <span className="font-sans text-sm">{item.value}</span>
                             <ChevronRight size={16} className="opacity-50" />
                         </div>
                     </motion.div>
                 ))}

                 {/* Divider */}
                 <div className="my-6 border-t border-ink/10"></div>

                 <motion.div 
                    whileHover={{ x: 4, backgroundColor: 'rgba(239, 68, 68, 0.05)' }}
                    className="flex items-center justify-between p-4 rounded-lg cursor-pointer group text-red-500/80 hover:text-red-600"
                 >
                     <div className="flex items-center gap-4">
                         <div className="p-2 bg-red-500/5 rounded-full group-hover:bg-red-500/10 transition-colors">
                            <LogOut size={20} />
                         </div>
                         <span className="font-serif text-lg font-medium">退出登录</span>
                     </div>
                 </motion.div>
             </div>
        </div>

        <div className="mt-8 text-center text-ink/30 text-xs font-serif italic">
            让记忆在时间中流淌 · MindFlow
        </div>
      </motion.div>
    </div>
  );
};
