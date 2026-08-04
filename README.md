# 可伴 AI



可伴
衣橱里的温柔时光

清晨的第一缕光落在衣柜门前，你打开它——不是为了迎合谁的眼光，只是想知道，今天的自己，该是什么样子。

可伴，一个只属于你的穿搭陪伴。它不问你是谁，不记你去过哪里，也不会在不合时宜的时候发出声响。它只在你想穿衣的那一刻，安静地站在你身边，像认识你很久的朋友，轻声说一句：今天试试这个吧。

你可以把心情说给它听，让它为你挑一身恰到好处的衣裳；也可以翻翻过往的穿搭日记，看见自己一路走来的样子——那些你几乎忘了的某一天，其实都被温柔地留在了这里。

没有社交，没有比较，没有打分的眼神。你的风格不需要被点赞，只需被自己看见。

打开它，是衣橱。合上它，是日常。

每一件衣服，都记得你穿过的样子。




> 每一件衣服，都记得你穿过的样子。

可伴 AI 是一款完全运行在本地的 AI 穿搭陪伴应用。

它不关心你的账号、不追踪你的数据、不打扰你的通知——
它只在你打开衣橱的那一刻，安静地帮你搭配好今天的心情。

---

### 它能做什么

- **今日穿搭** — 根据天气与心情，推荐今日最合宜的搭配
- **AI 搭配** — 从你的衣橱中挑选衣物，一键生成风格方案
- **穿搭日记** — 记录每一天的穿着，留下属于自己的风格记忆
- **我的衣橱** — 整理衣物分类，让每一件单品都有迹可循
- **灵感画廊** — 浏览搭配灵感，发现未曾尝试的可能
- **AI 语聊陪伴** — 和一个懂审美的伙伴，聊聊今天穿什么

---

### 设计理念

没有社交，没有比较，没有信息流。

可伴相信，穿衣是一件私人的、温柔的事。
你的风格不需要被点赞，只需要被自己看见。

所有数据仅存于你的设备，无需注册，无需联网。
打开即是你的衣橱，合上便是一段安静的日常。

---

### 技术栈

Flutter · Dart · SharedPreferences · 纯本地架构

---

## 开发文档

以下为项目详细的技术设计与架构说明。

---

# 一、整体 APP 定位

APP 名称示例：

```
可伴 AI
```

核心功能：

```
今日穿搭
      ↓
AI搭配生成
      ↓
可伴
      ↓
我的衣橱
      ↓
穿搭灵感
      ↓
AI语聊陪伴
```

完全本地：

```
用户数据
   |
shared_preferences
   |
JSON String
   |
Model
   |
setState刷新UI
```

---

# 二、Flutter项目目录结构

```
lib/

├── main.dart

├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme/
│       └── app_colors.dart


├── core/

│   ├── constants/
│   │   ├── app_strings.dart
│   │   └── asset_paths.dart
│   │

│   ├── storage/
│   │   └── local_storage.dart
│   │

│   ├── utils/
│   │   ├── date_utils.dart
│   │   └── json_utils.dart
│   │


├── models/


│   ├── clothing_item.dart
│   ├── outfit.dart
│   ├── diary.dart
│   ├── ai_style.dart
│   └── wardrobe.dart



├── data/


│   ├── mock/
│   │   └── mock_data.dart
│   │
│   └── repository/
│       ├── wardrobe_repository.dart
│       ├── diary_repository.dart
│       └── outfit_repository.dart



├── pages/


│   ├── home/
│   │
│   │── home_page.dart
│   │── widgets/
│   │    ├── today_card.dart
│   │    ├── outfit_card.dart
│   │    └── quick_action.dart
│   │


│   ├── ai_styling/
│   │
│   │── ai_page.dart
│   │── widgets/
│   │    ├── upload_clothes.dart
│   │    ├── style_selector.dart
│   │    └── result_card.dart



│   ├── diary/
│   │
│   │── diary_page.dart
│   │── widgets/
│        └── diary_item.dart



│   ├── wardrobe/
│   │
│   │── wardrobe_page.dart
│   │── widgets/
│        └── category_card.dart



│   ├── inspiration/
│   │
│   │── inspiration_page.dart



│   └── ai_room/
│       │
│       └── ai_room_page.dart



├── widgets/


│   ├── app_bottom_bar.dart
│   ├── app_card.dart
│   ├── gradient_button.dart
│   └── empty_view.dart



└── assets/

    ├── images/
    ├── clothes/
    ├── characters/
    └── decorations/

```

---

# 三、页面结构设计

## 1. 首页 Home

对应 UI：

```
今日穿搭
```

功能：

* 今日日期
* 天气
* 今日推荐
* 快速记录
* AI生成

结构：

```
HomePage

State:

DateTime today;

Outfit todayOutfit;

String weather;


setState()

      |
      |
 TodayCard

 OutfitCard

 QuickAction

```

---

## 2. AI穿搭页面

```
AIPage
```

状态：

```dart
class _AIPageState extends State<AIPage>{


List<ClothingItem> selectedItems=[];


String scene="通勤";


String style="简约";


Outfit? result;


void generate(){

setState((){

result = MockData.generate();

});

}


}
```

流程：

```
选择衣服

↓

选择场景

↓

选择风格

↓

生成搭配

↓

展示结果

```

---

# 四、Model设计

不用 freezed。

全部普通 Dart class。

---

## ClothingItem

```dart
class ClothingItem {


String id;

String name;

String type;

String image;


ClothingItem({

required this.id,

required this.name,

required this.type,

required this.image,

});


Map<String,dynamic> toJson(){

return {

"id":id,

"name":name,

"type":type,

"image":image

};

}


factory ClothingItem.fromJson(
Map<String,dynamic> json){

return ClothingItem(

id:json["id"],

name:json["name"],

type:json["type"],

image:json["image"],

);

}


}
```

---

# Outfit

```dart
class Outfit {


String title;


List<String> clothes;


String style;


String description;



Outfit({

required this.title,

required this.clothes,

required this.style,

required this.description

});


}
```

---

# Diary

```dart
class Diary {


String date;


String image;


String mood;


String weather;


List<String> tags;



Diary({

required this.date,

required this.image,

required this.mood,

required this.weather,

required this.tags,

});


}
```

---

# 五、本地存储设计

使用：

```
shared_preferences
```

不用数据库。

---

## LocalStorage

```dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';



class LocalStorage {



static Future saveDiary(
List diary) async{


final sp =
await SharedPreferences.getInstance();


sp.setString(

"diary",

jsonEncode(diary)

);


}



static Future<List> getDiary()
async{


final sp =
await SharedPreferences.getInstance();


String? data =
sp.getString("diary");


if(data==null){

return [];

}


return jsonDecode(data);


}


}
```

---

# 六、数据存储内容

SharedPreferences:

```
keys:

wardrobe

diary

favorite_style

ai_history

setting

```

---

例如：

## 衣橱

```json
{
"wardrobe":[

{
"name":"米色西装",
"type":"外套",
"image":"assets/clothes/blazer.png"
}

]
}

```

---

# 七、Bottom Navigation

对应6个页面：

```
今日穿搭

AI穿搭

可伴

我的衣橱

灵感首页

AI陪伴

```

---

代码：

```dart
class AppBottomBar extends StatelessWidget {


final int index;


final Function(int) onTap;



const AppBottomBar({

required this.index,

required this.onTap

});



@override

Widget build(BuildContext context){


return BottomNavigationBar(

currentIndex:index,


onTap:onTap,


items:[


BottomNavigationBarItem(

icon:Icon(Icons.home),

label:"今日"

),


BottomNavigationBarItem(

icon:Icon(Icons.auto_awesome),

label:"AI"

),


BottomNavigationBarItem(

icon:Icon(Icons.calendar_month),

label:"日记"

),


BottomNavigationBarItem(

icon:Icon(Icons.checkroom),

label:"衣橱"

),


BottomNavigationBarItem(

icon:Icon(Icons.image),

label:"灵感"

),


BottomNavigationBarItem(

icon:Icon(Icons.mic),

label:"陪伴"

),


]


);


}


}
```

---

# 八、图片资源规划

根据你生成的绿幕素材：

```
assets/

images/

   home/

      today_bg.png


clothes/

   blazer.png

   dress.png

   bag.png

   shoes.png


characters/

   girl01.png

   ai_robot.png


decorations/

   sparkle.png

   card_bg.png

   waveform.png

```

---

# 九、APP状态流

## 首页

```
LocalStorage

↓

HomePage

↓

setState

↓

刷新推荐穿搭

```

## AI生成

```
用户选择

衣服

场景

风格


↓

AI算法模拟


↓

Outfit Model


↓

setState


↓

ResultCard

```

---

# 十、不包含功能

明确排除：

❌ 登录

❌ 注册

❌ 用户中心

❌ 好友

❌ 私信

❌ 评论

❌ 点赞

❌ 粉丝

❌ 社区

❌ 推送通知

❌ 消息中心

❌ 分享

❌ 主题切换

❌ 深色模式

---

# 十一、依赖 pubspec.yaml

最终只需要：

```yaml
dependencies:

 flutter:
   sdk:flutter


 shared_preferences:
   ^2.2.3


 cupertino_icons:
   ^1.0.8


 intl:
   ^0.19.0
```

不需要：

```
❌ freezed

❌ json_serializable

❌ build_runner

❌ cached_network_image

❌ google_fonts

❌ share_plus

❌ firebase

❌ provider

❌ riverpod

❌ bloc

```

---

# 十二、推荐开发顺序

## Phase 1

完成静态 UI

```
Home

AI

Diary

Wardrobe

```

---

## Phase 2

加入本地数据

```
衣橱添加

日记保存

搭配历史

```

---

## Phase 3

AI模拟逻辑

```
标签匹配

颜色匹配

场景匹配

```

---

## Phase 4

优化动画

```
Hero

AnimatedContainer

FadeTransition

```

---

这个架构可以直接支撑你目前的 **6屏 UI 产品原型 → Flutter MVP → 上架版本**，同时保持代码简单，没有引入复杂状态管理。
————
图片资源：
/Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_robot_icon_001.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_robot_icon_055.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_robot_icon_109.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_robot_icon_163.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_robot_icon_217.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_robot_icon_271.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_sparkle_icon_002.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_sparkle_icon_056.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_sparkle_icon_110.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_sparkle_icon_164.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_sparkle_icon_218.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/ai_sparkle_icon_272.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/avatar_female_050.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/avatar_female_104.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/avatar_female_158.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/avatar_female_212.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/avatar_female_266.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/avatar_male_051.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/avatar_male_105.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/avatar_male_159.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/avatar_male_213.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/avatar_male_267.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bag_icon_019.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bag_icon_073.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bag_icon_127.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bag_icon_181.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bag_icon_235.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bag_icon_289.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/beige_trench_029.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/beige_trench_083.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/beige_trench_137.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/beige_trench_191.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/beige_trench_245.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/book_prop_044.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/book_prop_098.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/book_prop_152.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/book_prop_206.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/book_prop_260.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bookmark_icon_009.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bookmark_icon_063.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bookmark_icon_117.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bookmark_icon_171.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bookmark_icon_225.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/bookmark_icon_279.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/boots_ankle_041.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/boots_ankle_095.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/boots_ankle_149.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/boots_ankle_203.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/boots_ankle_257.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/calendar_icon_006.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/calendar_icon_060.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/calendar_icon_114.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/calendar_icon_168.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/calendar_icon_222.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/calendar_icon_276.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/casual_dress_034.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/casual_dress_088.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/casual_dress_142.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/casual_dress_196.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/casual_dress_250.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/chair_decor_047.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/chair_decor_101.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/chair_decor_155.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/chair_decor_209.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/chair_decor_263.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/closet_scene_049.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/closet_scene_103.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/closet_scene_157.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/closet_scene_211.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/closet_scene_265.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/coffee_cup_prop_043.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/coffee_cup_prop_097.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/coffee_cup_prop_151.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/coffee_cup_prop_205.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/coffee_cup_prop_259.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/cream_blazer_025.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/cream_blazer_079.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/cream_blazer_133.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/cream_blazer_187.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/cream_blazer_241.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/denim_jacket_030.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/denim_jacket_084.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/denim_jacket_138.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/denim_jacket_192.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/denim_jacket_246.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/dress_icon_017.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/dress_icon_071.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/dress_icon_125.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/dress_icon_179.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/dress_icon_233.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/dress_icon_287.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/fashion_character_052.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/fashion_character_106.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/fashion_character_160.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/fashion_character_214.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/fashion_character_268.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/favorite_heart_icon_010.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/favorite_heart_icon_064.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/favorite_heart_icon_118.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/favorite_heart_icon_172.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/favorite_heart_icon_226.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/favorite_heart_icon_280.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/floral_dress_033.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/floral_dress_087.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/floral_dress_141.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/floral_dress_195.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/floral_dress_249.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/glasses_icon_022.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/glasses_icon_076.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/glasses_icon_130.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/glasses_icon_184.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/glasses_icon_238.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_beige_035.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_beige_089.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_beige_143.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_beige_197.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_beige_251.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_black_037.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_black_091.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_black_145.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_black_199.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_black_253.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_lavender_036.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_lavender_090.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_lavender_144.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_lavender_198.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/handbag_lavender_252.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hanger_icon_015.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hanger_icon_069.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hanger_icon_123.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hanger_icon_177.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hanger_icon_231.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hanger_icon_285.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hat_icon_021.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hat_icon_075.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hat_icon_129.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hat_icon_183.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/hat_icon_237.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/heels_nude_040.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/heels_nude_094.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/heels_nude_148.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/heels_nude_202.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/heels_nude_256.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/jewelry_icon_024.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/jewelry_icon_078.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/jewelry_icon_132.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/jewelry_icon_186.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/jewelry_icon_240.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/lavender_cardigan_027.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/lavender_cardigan_081.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/lavender_cardigan_135.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/lavender_cardigan_189.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/lavender_cardigan_243.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/loafer_beige_039.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/loafer_beige_093.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/loafer_beige_147.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/loafer_beige_201.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/loafer_beige_255.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mic_button_004.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mic_button_058.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mic_button_112.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mic_button_166.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mic_button_220.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mic_button_274.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mirror_decor_046.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mirror_decor_100.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mirror_decor_154.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mirror_decor_208.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/mirror_decor_262.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/outfit_set_053.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/outfit_set_107.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/outfit_set_161.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/outfit_set_215.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/outfit_set_269.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pause_button_005.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pause_button_059.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pause_button_113.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pause_button_167.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pause_button_221.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pause_button_275.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pink_blouse_026.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pink_blouse_080.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pink_blouse_134.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pink_blouse_188.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pink_blouse_242.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pleated_skirt_032.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pleated_skirt_086.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pleated_skirt_140.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pleated_skirt_194.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/pleated_skirt_248.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/privacy_lock_icon_007.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/privacy_lock_icon_061.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/privacy_lock_icon_115.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/privacy_lock_icon_169.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/privacy_lock_icon_223.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/privacy_lock_icon_277.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/room_decor_048.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/room_decor_102.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/room_decor_156.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/room_decor_210.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/room_decor_264.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/scarf_icon_023.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/scarf_icon_077.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/scarf_icon_131.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/scarf_icon_185.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/scarf_icon_239.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/security_shield_icon_008.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/security_shield_icon_062.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/security_shield_icon_116.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/security_shield_icon_170.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/security_shield_icon_224.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/security_shield_icon_278.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shirt_icon_018.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shirt_icon_072.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shirt_icon_126.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shirt_icon_180.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shirt_icon_234.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shirt_icon_288.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shoe_icon_020.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shoe_icon_074.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shoe_icon_128.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shoe_icon_182.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/shoe_icon_236.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/sneaker_white_038.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/sneaker_white_092.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/sneaker_white_146.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/sneaker_white_200.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/sneaker_white_254.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/style_card_054.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/style_card_108.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/style_card_162.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/style_card_216.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/style_card_270.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/tulip_decor_045.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/tulip_decor_099.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/tulip_decor_153.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/tulip_decor_207.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/tulip_decor_261.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/umbrella_pastel_042.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/umbrella_pastel_096.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/umbrella_pastel_150.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/umbrella_pastel_204.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/umbrella_pastel_258.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/voice_waveform_003.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/voice_waveform_057.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/voice_waveform_111.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/voice_waveform_165.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/voice_waveform_219.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/voice_waveform_273.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wardrobe_closet_icon_016.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wardrobe_closet_icon_070.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wardrobe_closet_icon_124.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wardrobe_closet_icon_178.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wardrobe_closet_icon_232.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wardrobe_closet_icon_286.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_cloudy_icon_012.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_cloudy_icon_066.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_cloudy_icon_120.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_cloudy_icon_174.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_cloudy_icon_228.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_cloudy_icon_282.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_night_icon_014.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_night_icon_068.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_night_icon_122.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_night_icon_176.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_night_icon_230.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_night_icon_284.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_rain_icon_013.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_rain_icon_067.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_rain_icon_121.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_rain_icon_175.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_rain_icon_229.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_rain_icon_283.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_sunny_icon_011.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_sunny_icon_065.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_sunny_icon_119.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_sunny_icon_173.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_sunny_icon_227.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/weather_sunny_icon_281.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/white_shirt_028.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/white_shirt_082.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/white_shirt_136.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/white_shirt_190.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/white_shirt_244.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wide_leg_pants_031.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wide_leg_pants_139.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wide_leg_pants_247.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wide_leg_pants_193.png /Users/admin/Desktop/Flutter_app/20260729-kexing/kexingcda/assets/wide_leg_pants_085.png