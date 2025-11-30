
import { DiaryEntry, CardStack, SquarePost, ChatMessage } from './types';

export const MOOD_COLORS = {
  joy: '#E9C46A',
  calm: '#2A9D8F',
  anxiety: '#E76F51',
  sadness: '#457B9D',
};

// Initial Sample Data
const TODAY = new Date();
const ONE_DAY = 24 * 60 * 60 * 1000;

const sampleEntries: DiaryEntry[] = [
  {
    id: 'e1',
    date: new Date(TODAY.getTime() - ONE_DAY * 0).toISOString(),
    content: "今天开始整理我的书桌。移动这些实体物件有一种莫名的治愈感。感觉就像在整理我的思绪一样。",
    image: "https://images.unsplash.com/photo-1497215728101-856f4ea42174?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80",
    mood: 'calm',
    location: '书房',
    aiInsight: '清理空间往往映射出清理思绪的渴望。你在寻求内心的清晰。',
    aiTags: ['清晰', '专注']
  },
  {
    id: 'e2',
    date: new Date(TODAY.getTime() - ONE_DAY * 1).toISOString(),
    content: "市中心的咖啡馆太吵了。根本看不进书。被人潮淹没的感觉让我有点喘不过气。",
    mood: 'anxiety',
    location: '星巴克中心店',
    aiInsight: '感官过载会消耗能量。下次试试降噪耳机，或者找个公园长椅。',
    aiTags: ['过载', '噪音']
  },
  {
    id: 'e3',
    date: new Date(TODAY.getTime() - ONE_DAY * 2).toISOString(),
    content: "意外碰到了大学老同学！我们聊了好几个小时，感叹大家变化真大。笑得我肚子都疼了。",
    image: "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80",
    mood: 'joy',
    location: '河滨步道',
    aiInsight: '重逢的喜悦是强大的力量。这些时刻将我们锚定在时间线上。',
    aiTags: ['友谊', '怀旧']
  },
  {
    id: 'e4',
    date: new Date(TODAY.getTime() - ONE_DAY * 3).toISOString(),
    content: "下雨天。待在家里看老电影。感觉有点孤单，不过是那种舒适的孤单。",
    mood: 'sadness',
    location: '卧室',
    aiInsight: '独处不等于孤独。拥抱雨天，让压力随之冲刷而去。',
    aiTags: ['独处', '休息']
  },
  {
    id: 'e5',
    date: new Date(TODAY.getTime() - ONE_DAY * 4).toISOString(),
    content: "大项目的截止日期快到了。我在全力以赴，进展还算顺利。团队氛围也不错。",
    mood: 'calm',
    location: '办公室',
    aiInsight: '稳定的进展是焦虑的解药。保持这种势头。',
    aiTags: ['工作', '进展']
  }
];

// Helper to create initial stacks from entries
export const INITIAL_STACKS: CardStack[] = sampleEntries.map((entry, index) => ({
  id: `stack-${entry.id}`,
  cards: [entry],
  zIndex: index,
  position: { x: 0, y: 0 } // Positions will be calculated by layout engine
}));

export const INITIAL_SQUARE_POSTS: SquarePost[] = [
  { 
    id: 's1', 
    author: '爱丽丝', 
    color: '#E9C46A', 
    content: "刚刚看到了最美的日落。生活中的小确幸。", 
    image: "https://images.unsplash.com/photo-1472120435266-531128262475?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80",
    likes: 12, 
    isLiked: false, 
    angle: -2 
  },
  { 
    id: 's2', 
    author: '鲍勃', 
    color: '#457B9D', 
    content: "有时候，什么都不做也是可以的。放空大脑。", 
    likes: 45, 
    isLiked: false, 
    angle: 1.5 
  },
  { 
    id: 's3', 
    author: '查理', 
    color: '#2A9D8F', 
    content: "植物终于发芽了！🌱 看着生命生长太奇妙了。", 
    image: "https://images.unsplash.com/photo-1453904300235-0f76960e2752?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80",
    likes: 8, 
    isLiked: false, 
    angle: -1 
  },
  { 
    id: 's4', 
    author: '达娜', 
    color: '#E76F51', 
    content: "焦虑是个骗子。你其实很棒。送给所有正在挣扎的人。", 
    likes: 120, 
    isLiked: true, 
    angle: 2 
  },
  { 
    id: 's5', 
    author: '夏娃', 
    color: '#E9C46A', 
    content: "这个冰淇淋能治愈一切坏心情。", 
    image: "https://images.unsplash.com/photo-1549395156-6ea887843e95?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80",
    likes: 33, 
    isLiked: false, 
    angle: 0.5 
  },
];

export const INITIAL_CHAT: ChatMessage[] = [
  { id: 'c1', sender: 'AI', text: "晚上好。牌桌已经准备好了。今天的感觉如何？" },
];
