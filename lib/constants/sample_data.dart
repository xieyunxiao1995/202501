import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../models/card_stack.dart';
import '../models/square_post.dart';

class SampleData {
  static List<DiaryEntry> getSampleEntries() {
    final now = DateTime.now();
    return [
      DiaryEntry(
        id: 'e1',
        date: now,
        content: '今天开始整理我的书桌。移动这些实体物件有一种莫名的治愈感。感觉就像在整理我的思绪一样。',
        image: 'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400',
        mood: Mood.calm,
        location: '书房',
        aiInsight: '清理空间往往映射出清理思绪的渴望。你在寻求内心的清晰。',
        aiTags: ['清晰', '专注'],
      ),
      DiaryEntry(
        id: 'e2',
        date: now.subtract(const Duration(days: 1)),
        content: '市中心的咖啡馆太吵了。根本看不进书。被人潮淹没的感觉让我有点喘不过气。',
        image: 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400',
        mood: Mood.anxiety,
        location: '星巴克中心店',
        aiInsight: '感官过载会消耗能量。下次试试降噪耳机，或者找个公园长椅。',
        aiTags: ['过载', '噪音'],
      ),
      DiaryEntry(
        id: 'e3',
        date: now.subtract(const Duration(days: 2)),
        content: '意外碰到了大学老同学！我们聊了好几个小时，感叹大家变化真大。笑得我肚子都疼了。',
        image: 'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=400',
        mood: Mood.joy,
        location: '河滨步道',
        aiInsight: '重逢的喜悦是强大的力量。这些时刻将我们锚定在时间线上。',
        aiTags: ['友谊', '怀旧'],
      ),
      DiaryEntry(
        id: 'e4',
        date: now.subtract(const Duration(days: 3)),
        content: '下雨天。待在家里看老电影。感觉有点孤单，不过是那种舒适的孤单。',
        image: 'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400',
        mood: Mood.sadness,
        location: '卧室',
        aiInsight: '独处不等于孤独。拥抱雨天，让压力随之冲刷而去。',
        aiTags: ['独处', '休息'],
      ),
      DiaryEntry(
        id: 'e5',
        date: now.subtract(const Duration(days: 4)),
        content: '大项目的截止日期快到了。我在全力以赴，进展还算顺利。团队氛围也不错。',
        image: 'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=400',
        mood: Mood.calm,
        location: '办公室',
        aiInsight: '稳定的进展是焦虑的解药。保持这种势头。',
        aiTags: ['工作', '进展'],
      ),
    ];
  }

  static List<CardStack> getInitialStacks() {
    final entries = getSampleEntries();
    return entries.asMap().entries.map((e) {
      return CardStack(
        id: 'stack-${e.value.id}',
        cards: [e.value],
        zIndex: e.key,
        position: Offset(0, 0),
      );
    }).toList();
  }

  static List<SquarePost> getSamplePosts() {
    final images = [
      'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400', // 山景
      'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=400', // 咖啡
      'https://images.unsplash.com/photo-1511632765486-a01980e01a18?w=400', // 人群
      'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400', // 雨天
      'https://images.unsplash.com/photo-1484480974693-6ca0a78fb36b?w=400', // 书桌
      'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?w=400', // 办公室
      'https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400', // 日落
      'https://images.unsplash.com/photo-1470071459604-3b5ec3a7fe05?w=400', // 自然
      'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?w=400', // 风景
      'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400', // 自然
      'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?w=400', // 猫咪
      'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=400', // 猫
      'https://images.unsplash.com/photo-1517849845537-4d257902454a?w=400', // 狗狗
      'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=400', // 狗
      'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?w=400', // 食物
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400', // 美食
      'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=400', // 海滩
      'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=400', // 海洋
      'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=400', // 湖泊
      'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=400', // 森林
      'https://images.unsplash.com/photo-1502082553048-f009c37129b9?w=400', // 城市
      'https://images.unsplash.com/photo-1480714378408-67cf0d13bc1b?w=400', // 建筑
      'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=400', // 星空
      'https://images.unsplash.com/photo-1465146344425-f00d5f5c8f07?w=400', // 花朵
      'https://images.unsplash.com/photo-1426604966848-d7adac402bff?w=400', // 植物
      'https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=400', // 编程
      'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?w=400', // 学习
      'https://images.unsplash.com/photo-1495521821757-a1efb6729352?w=400', // 阅读
      'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=400', // 甜点
      'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400', // 冰淇淋
      'https://images.unsplash.com/photo-1511367461989-f85a21fda167?w=400', // 音乐
      'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400', // 家居
      'https://images.unsplash.com/photo-1487700160041-babef9c3cb55?w=400', // 工作
      'https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=400', // 笔记本
      'https://images.unsplash.com/photo-1452421822248-d4c2b47f0c81?w=400', // 旅行
      'https://images.unsplash.com/photo-1488646953014-85cb44e25828?w=400', // 相机
      'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400', // 手表
      'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400', // 耳机
      'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400', // 电脑
      'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400', // 人物
      'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?w=400', // 运动
      'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=400', // 健身
      'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?w=400', // 瑜伽
      'https://images.unsplash.com/photo-1506126613408-eca07ce68773?w=400', // 时尚
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?w=400', // 时装
      'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=400', // 汽车
      'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400', // 摩托车
      'https://images.unsplash.com/photo-1473496169904-658ba7c44d8a?w=400', // 自行车
      'https://images.unsplash.com/photo-1502139214982-d0ad755818d8?w=400', // 滑板
      'https://images.unsplash.com/photo-1511285560929-80b456fea0bc?w=400', // 篮球
    ];
    
    final contents = [
      '刚刚看到了最美的日落。生活中的小确幸。',
      '有时候，什么都不做也是可以的。放空大脑。',
      '植物终于发芽了！🌱 看着生命生长太奇妙了。',
      '焦虑是个骗子。你其实很棒。送给所有正在挣扎的人。',
      '这个冰淇淋能治愈一切坏心情。',
      '今天的咖啡特别香，配上窗外的阳光，完美。',
      '终于完成了那个困扰我很久的项目，成就感满满！',
      '雨后的空气总是特别清新，心情也跟着好起来。',
      '和朋友聊了一整晚，笑到肚子疼。',
      '读完了一本好书，感觉整个人都被治愈了。',
      '早起看日出，发现世界真的很美。',
      '做了一顿美味的晚餐，犒劳辛苦的自己。',
      '听到了一首很久以前的歌，回忆涌上心头。',
      '今天的天空蓝得不像话，心情也跟着飞起来。',
      '散步时遇到了一只超可爱的小猫。',
      '终于学会了那个一直想学的技能，太开心了！',
      '和家人视频聊天，虽然不在一起但心很近。',
      '今天的运动让我感觉充满活力。',
      '写下这些文字的时候，感觉心里很平静。',
      '发现了一家超棒的小店，下次还要来。',
      '今天的月亮特别圆，想起了远方的朋友。',
      '整理房间的时候，找到了很多珍贵的回忆。',
      '尝试了新的发型，感觉像换了一个人。',
      '今天的工作很顺利，一切都在掌控之中。',
      '看了一部很感人的电影，眼泪止不住。',
      '突然想明白了一件事，豁然开朗。',
      '今天的晚霞美得像一幅画。',
      '收到了朋友的礼物，感动到哭。',
      '学会了放下，感觉轻松了很多。',
      '今天的自己，比昨天更好一点。',
      '遇到了一个很温暖的陌生人。',
      '终于鼓起勇气做了一直想做的事。',
      '今天的笑容是发自内心的。',
      '感谢生活中的每一个小美好。',
      '今天的我，值得被爱。',
      '慢慢来，一切都会好起来的。',
      '今天又是充满希望的一天。',
      '学会了接纳不完美的自己。',
      '生活总是在不经意间给你惊喜。',
      '今天的风很温柔，像是在拥抱我。',
      '第一次尝试做瑜伽，虽然动作不标准但感觉很放松。',
      '路边的小花开得正艳，停下来拍了好多照片。',
      '今天终于把拖了很久的事情做完了，如释重负。',
      '夜跑的时候看到满天星星，城市的夜晚也可以很美。',
      '学会了一道新菜，味道竟然还不错！',
      '重新整理了书架，每本书都是一段回忆。',
      '今天的云朵像棉花糖，想伸手去摸一摸。',
      '和陌生人的一次对话，让我对生活有了新的理解。',
      '音乐响起的那一刻，所有烦恼都消失了。',
      '第一次尝试冥想，感觉找到了内心的平静。',
      '今天的自己，勇敢地说出了心里话。',
      '窗外的雨声，是最好的白噪音。',
      '翻到了小时候的照片，那时候的笑容真纯真。',
      '今天没有刷手机，专心做了一件事，效率超高。',
      '路过花店，给自己买了一束花，生活需要仪式感。',
      '今天的阳光洒在脸上，暖暖的，很舒服。',
      '学会了说不，感觉自己成长了一点点。',
      '深夜的城市很安静，适合思考人生。',
      '今天笑了好多次，原来快乐可以这么简单。',
      '尝试了新的发色，感觉像换了一个人生。',
      '和宠物玩了一下午，它的快乐感染了我。',
      '今天的晚餐特别好吃，幸福就是这么简单。',
      '终于把想看的电影都看完了，满足感爆棚。',
      '今天的步数破了记录，给自己点个赞。',
      '学会了接受不完美，生活轻松了很多。',
      '今天的心情像天气一样晴朗。',
      '做了一个很美的梦，醒来还在笑。',
      '今天的自己，比想象中更坚强。',
      '发现了一家超好吃的餐厅，下次要带朋友来。',
      '今天的夕阳特别美，拍了好多照片。',
      '学会了一个新技能，感觉自己又进步了。',
      '今天的音乐特别好听，单曲循环了一整天。',
      '和老朋友重逢，聊了很多往事。',
      '今天的自己，值得所有的美好。',
      '学会了放慢脚步，享受当下的每一刻。',
      '今天的笑容，是送给自己最好的礼物。',
      '发现生活中处处都是小确幸。',
      '今天的自己，充满了正能量。',
      '学会了感恩，心里充满了温暖。',
      '今天的天空特别蓝，心情也跟着好起来。',
    ];
    
    final authors = [
      '爱丽丝', '鲍勃', '查理', '达娜', '夏娃', '弗兰克', '格蕾丝', '亨利',
      '艾薇', '杰克', '凯特', '利亚姆', '玛雅', '诺亚', '奥利维亚', '帕克',
      '昆恩', '瑞秋', '山姆', '泰勒', '乌玛', '维克多', '温蒂', '泽维尔',
      '佐伊', '亚历克斯', '贝拉', '卡洛斯', '黛安娜', '伊森', '菲奥娜', '加布里埃尔',
      '汉娜', '伊恩', '茉莉', '凯文', '露西', '马克斯', '妮娜', '奥斯卡',
    ];
    
    final colors = [
      '#E9C46A', '#457B9D', '#2A9D8F', '#E76F51', '#F4A261',
      '#264653', '#E63946', '#F1FAEE', '#A8DADC', '#1D3557',
    ];
    
    return List.generate(80, (index) {
      return SquarePost(
        id: 's${index + 1}',
        author: authors[index % authors.length],
        color: colors[index % colors.length],
        content: contents[index % contents.length],
        image: images[index % images.length], // 每个卡牌都有图片
        likes: (index * 7 + 5) % 150,
        isLiked: index == 3 || index == 15 || index == 28,
        angle: (index % 5 - 2) * 0.8,
      );
    });
  }
}
