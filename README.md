# 星悦

> 每一件衣服，都藏着一段心情。

## 简介

星悦是一款陪伴你发现自我的日记应用。

我们相信，每一个平凡的日子都值得被记录——那些细微的情绪波动、偶然闪现的灵感、不经意间的心动，都是生命中最真实的片段。

星悦帮你珍藏这些时光：此刻的心情、今日的风景、那些无法言说却真实存在的感受。时间久了，你会看见自己的成长轨迹——原来阴天需要温暖，晴天渴望自由；原来某些瞬间总与某些记忆相连。

这里没有标准答案，只有真实的你。

## 核心理念

- 陪伴：记录每一个当下，让时光有迹可循
- 觉察：看见情绪与日常的微妙联系，更懂自己
- 启发：在对话中获得灵感，发现生活的更多可能
- 共鸣：与同频的人分享故事，感受彼此的温度
- 探索：回望来时的路，遇见更完整的自己

## 副标题候选

1. 记录日常，遇见更好的自己
2. 每一个平凡的日子，都值得被珍藏
3. 生活有温度，岁月有故事
4. 今天过得好吗？让时光告诉你
5. 记录每一天的风景与心情
6. 生活不止于忙碌，更在于感受
7. 你的日常，你的心情，你的故事
8. 用文字记录生活的小确幸
9. 岁月里的心情日记
10. 活出心情，悦见每一天
11. 风格不是选择，而是发现
12. 生活是写给世界的情书
13. 懂生活，更懂你的心情
14. 每一天的你，都值得被记录
15. 从日常开始，认识自己
16. 生活有态度，岁月有温度
17. 把日子过成诗，让时光有回音
18. 在平凡中发现不凡的自己
19. 时光不语，却记得所有美好
20. 用心生活，万物皆有光

---

## App Store Review 回复

### 中文版本

Dear Apple Review Team,

Thank you for your review and feedback.

Regarding Guideline 2.1(a) - Information Needed:

Our app does not require any account login or registration. All features are immediately accessible upon first launch without authentication. The app is designed as a personal diary/journal tool that works locally without user accounts.

To help you verify all features and functionality:

1. **No Account Required**: Simply open the app to access all features. There is no login screen or account system.
2. **Pre-populated Content**: The app includes sample diary entries and content that are visible immediately upon launch.
3. **Demo Video**: We have uploaded a demonstration video showing all app features in action: https://youtu.be/jIy97td_ilY

If you need any additional information or clarification, please don't hesitate to contact us.

Best regards,
星悦 Development Team

---

### English Version

Dear Apple Review Team,

Thank you for your review and feedback.

Regarding Guideline 2.1(a) - Information Needed:

Our app does not require any account login or registration. All features are immediately accessible upon first launch without authentication. The app is designed as a personal diary/journal tool that works locally without user accounts.

To help you verify all features and functionality:

1. **No Account Required**: Simply open the app to access all features. There is no login screen or account system.
2. **Pre-populated Content**: The app includes sample diary entries and content that are visible immediately upon launch.
3. **Demo Video**: We have uploaded a demonstration video showing all app features in action: https://youtu.be/jIy97td_ilY

If you need any additional information or clarification, please don't hesitate to contact us.

Best regards,
星悦 Development Team

---

## 开发说明

不使用 freezed 包和 part 语法
1. 状态管理先用setState
2. 数据存储可以用shared_preferences

5.不需要账户功能
6、不需要外部字体
不要 share_plus
--
火山云 豆包模型

curl https://ark.cn-beijing.volces.com/api/v3/responses \
-H "Authorization: Bearer 80f8c6ee-31bb-474c-9b9e-6207cc9a10f5" \
-H 'Content-Type: application/json' \
-d '{
    "model": "doubao-seed-1-8-251228",
    "input": [
        {
            "role": "user",
            "content": [
                {
                    "type": "input_image",
                    "image_url": "https://ark-project.tos-cn-beijing.volces.com/doc_image/ark_demo_img_1.png"
                },
                {
                    "type": "input_text",
                    "text": "你看见了什么？"
                }
            ]
        }
    ]
}'