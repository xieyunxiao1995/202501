
export type Mood = 'joy' | 'calm' | 'anxiety' | 'sadness';

export interface DiaryEntry {
  id: string;
  date: string; // ISO date string
  content: string;
  image?: string; // URL or Base64 string for the photo
  mood: Mood;
  aiInsight?: string;
  aiTags?: string[];
  location?: string;
}

// A Stack can contain one or more cards.
export interface CardStack {
  id: string;
  title?: string; // Auto-generated title for the stack
  cards: DiaryEntry[];
  zIndex: number;
  position: { x: number; y: number }; // Relative position on the table
}

export interface DragItem {
  type: 'STACK';
  id: string;
}

export type Page = 'HOME' | 'COMPANION' | 'SQUARE' | 'SETTINGS';

export interface SquarePost {
  id: string;
  author: string;
  color: string;
  content: string;
  image?: string;
  likes: number;
  isLiked: boolean;
  angle: number; // For the tilt effect
}

export interface ChatMessage {
  id: string;
  sender: 'USER' | 'AI';
  text: string;
}
