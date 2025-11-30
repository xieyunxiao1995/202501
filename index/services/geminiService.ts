import { GoogleGenAI, Type } from "@google/genai";
import { DiaryEntry } from "../types";

// Safety check for API Key
const getApiKey = (): string | undefined => {
  return process.env.API_KEY;
};

export const analyzeDiaryEntry = async (entry: DiaryEntry): Promise<{ insight: string; tags: string[] }> => {
  const apiKey = getApiKey();
  if (!apiKey) {
    console.warn("No API Key found. Returning mock insight.");
    return {
      insight: "深度的反思能为混乱的思绪带来清晰。(模拟数据)",
      tags: ["反思", "模拟数据"]
    };
  }

  const ai = new GoogleGenAI({ apiKey });

  try {
    const prompt = `
      请分析以下日记内容。
      提供一个简短、富有同理心且略带哲理的洞察（最多 20 个字），用以回应用户的情绪。
      同时提供 2 个简短的情绪关键词标签。
      请直接使用 JSON 格式返回，不要包含 Markdown 格式。
      
      日记内容: "${entry.content}"
      心情: ${entry.mood}
    `;

    const response = await ai.models.generateContent({
      model: "gemini-2.5-flash",
      contents: prompt,
      config: {
        responseMimeType: "application/json",
        responseSchema: {
          type: Type.OBJECT,
          properties: {
            insight: { type: Type.STRING },
            tags: { 
              type: Type.ARRAY,
              items: { type: Type.STRING }
            }
          }
        }
      }
    });

    const text = response.text;
    if (text) {
      return JSON.parse(text);
    }
    throw new Error("No response text");

  } catch (error) {
    console.error("Gemini Analysis Failed:", error);
    return {
      insight: "每一天都是你人生故事的新篇章。",
      tags: ["旅程", "生活"]
    };
  }
};