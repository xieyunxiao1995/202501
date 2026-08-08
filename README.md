# cardgame


Fugora-Solitaire


com.fugora.soli

中文：

Fugora-Solitaire 将经典纸牌接龙带入一场轻松的冒险之旅。完成关卡、解锁精美主题、体验寻宝、限时冲刺等创意玩法。纯粹的本地游戏，没有干扰，只有纸牌与宁静。

English：

Fugora-Solitaire brings classic solitaire into a relaxing adventure. Complete levels, unlock beautiful themes, and enjoy creative challenges including Treasure Hunt, Timed Rush, and Joker Rescue. Pure offline gameplay, no distractions — just cards and calm.





# Solitaire Journey

# Flutter 完整游戏架构设计文档（适合 Flutter 初学者）




不使用 freezed 包和 part 语法
1. 状态管理先用setState
2. 数据存储可以用shared_preferences
4. 不需要  cached_network_image
5.不需要账户功能
6、不需要外部字体，不需要google_fonts
不要 share_plus
目标：

* Flutter 开发
* 纯本地离线游戏
* 无账号系统
* 无服务器
* App Store 可发布
* 支持：

  * Classic Solitaire
  * Adventure Level
  * Theme换背景
  * Creative Modes
  * Daily Challenge
  * 本地存档

---

# 1. 技术架构总览

采用：

## MVC + Feature Module 架构

```
lib/

├── main.dart

├── app/
│   ├── app.dart
│   ├── routes.dart
│   └── theme.dart


├── core/
│   ├── constants/
│   ├── utils/
│   ├── storage/
│   └── widgets/


├── features/

│
├── home/
│   ├── home_screen.dart
│   ├── home_controller.dart
│   └── widgets/


│
├── solitaire/
│   ├── game_screen.dart
│   ├── game_controller.dart
│   ├── models/
│   └── widgets/


│
├── levels/
│   ├── level_screen.dart
│   ├── level_controller.dart
│   └── widgets/


│
├── themes/
│   ├── theme_screen.dart
│   ├── theme_controller.dart
│   └── widgets/


│
├── creative/
│   ├── creative_screen.dart
│   ├── creative_controller.dart
│   └── modes/


│
├── settings/
│   └── settings_screen.dart



├── data/

│
├── levels.json
├── themes.json
└── modes.json



└── assets/

    ├── images/

    ├── cards/

    ├── backgrounds/

    ├── icons/

    └── sounds/

```

---

# 2. Flutter依赖

pubspec.yaml

```yaml
dependencies:


 flutter:
   sdk: flutter


# 状态管理
provider: ^6.1.2


# 本地存储
shared_preferences: ^2.2.3


# 动画
animations: ^2.0.11


# 图标
cupertino_icons: ^1.0.8



```

---

# 3. App入口

main.dart

```dart
void main(){

 WidgetsFlutterBinding.ensureInitialized();


 runApp(
   SolitaireApp()
 );

}

```

---

# 4. App Router

routes.dart

```dart
class AppRoutes{


static const home="/";

static const game="/game";

static const levels="/levels";

static const themes="/themes";

static const creative="/creative";


}

```

页面流程：

```
Splash

 ↓

Home


 ↓


Level Map


 ↓


Game


 ↓


Win


 ↓


Reward


```

---

# 5. 数据模型设计

---

# Card Model

lib/features/solitaire/models/card_model.dart

```dart
class PlayingCard{


final String suit;

final int value;

bool faceUp;


PlayingCard({

required this.suit,

required this.value,

this.faceUp=false

});


}

```

---

# Card状态

```dart
enum CardSuit{

spade,

heart,

diamond,

club

}

```

---

# 6. 接龙游戏核心逻辑

GameController

负责：

* 发牌
* 移动
* 判断胜利
* Undo

结构：

```dart
class GameController extends ChangeNotifier{


List<List<PlayingCard>> columns=[];


List<PlayingCard> stock=[];


List<PlayingCard> waste=[];


List<List<PlayingCard>> foundation=[];



void moveCard(){}



void undo(){}



bool checkWin(){

return false;

}


}

```

---

# 7. 游戏UI组件

## Playing Card

```
widgets/


playing_card.dart

```

Flutter:

```dart
class PlayingCardWidget extends StatelessWidget{


final PlayingCard card;


Widget build(context){

return AnimatedContainer(

duration:
Duration(milliseconds:300),


child:

Image.asset(

card.faceUp ?

cardFront :

cardBack

)

);


}


}

```

---

# 8. 游戏布局

GameScreen

```
Scaffold


Stack


 |
 |
 ├── BackgroundImage
 |
 ├── TopBar
 |
 ├── FoundationArea
 |
 ├── StockArea
 |
 ├── TableauArea
 |
 └── BottomActionBar



```

---

# 9. Home模块

目录：

```
home/


home_screen.dart

widgets/


logo.dart

menu_card.dart

progress_card.dart


```

UI：

```
Solitaire Journey



[Daily Challenge]


[Continue Level 3-2]


[Classic Solitaire]


[Creative Modes]


Progress


Bottom Nav

```

---

# 10. Level系统

## Level Model

```dart
class Level{


int id;


String chapter;


int stars;


String goal;



}


```

JSON:

levels.json

```json
[
{
"id":1,

"chapter":"Beginner Road",

"goal":"clear",

"stars":3

}

]

```

---

# LevelController

```dart
class LevelController 
extends ChangeNotifier{


List<Level> levels=[];


void unlockNext(){}



}

```

---

# 11. Theme换肤系统

## Theme Model

```dart
class GameTheme{


String name;


String background;


}


```

themes.json

```json
[
{
"name":"Ocean",

"image":
"ocean.jpg"

},

{
"name":"Snow",

"image":
"snow.jpg"

}

]

```

---

# ThemeController

```dart
class ThemeController 
extends ChangeNotifier{


String current="green";


void changeTheme(String value){

current=value;

notifyListeners();

}


}

```

---

# 12. Creative Mode架构

目录：

```
creative/


modes/


treasure/

timed/

joker/

shadow/

locked/


```

统一接口：

```dart
abstract class GameMode{


String name;


void start();


bool checkRule();


}

```

---

# 13. Treasure Hunt

```dart
class TreasureMode 
extends GameMode{


int treasureCount=3;



bool checkRule(){

return collected==3;

}


}

```

---

# 14. Timed Rush

Timer:

```dart
Timer.periodic(

Duration(seconds:1),

(timer){

time--;

}

);

```

---

# 15. Joker Rescue

增加特殊卡

Card:

```dart
bool isJoker;


bool locked;

```

规则：

```
unlockCount >=3

解除joker

```

---

# 16. 本地存储

SharedPreferences

保存：

```json
{

"currentLevel":5,


"coins":2450,


"theme":"forest",


"stars":32


}

```

Storage:

```dart
class Storage{


save();


load();


}

```

---

# 17. Assets设计

```
assets/


images/


logo.png


backgrounds/


green.jpg

forest.jpg

snow.jpg

ocean.jpg



cards/


card_back_blue.png

card_back_red.png


icons/


hint.png

undo.png

theme.png



```

---

# 18. 状态管理

推荐 Provider

结构：

```
MultiProvider


 GameController


 LevelController


 ThemeController


 UserController



MaterialApp

```

代码：

```dart
MultiProvider(

providers:[


ChangeNotifierProvider(

create:(_)=>

GameController()

),



ChangeNotifierProvider(

create:(_)=>

ThemeController()

)


]


)

```

---

# 19. UI组件复用

统一：

```
widgets/


GameButton.dart


MenuCard.dart


GlassPanel.dart


StarRating.dart


LevelNode.dart


ThemeCard.dart


```

---

# 20. 动画设计

Flutter内置：

### 卡牌移动

```
AnimatedPositioned

```

### 翻牌

```
Transform.rotateY

```

### 获胜

```
Confetti

```

### Level解锁

```
ScaleTransition

```

---

# 21. MVP开发顺序（推荐）

## Phase 1 基础

时间：
1-2周

完成：

✅ UI

✅ 卡牌模型

✅ 发牌

✅ 移动

---

## Phase 2 游戏化

2周

完成：

✅ Level

✅ Stars

✅ Theme

---

## Phase 3 创意模式

2-3周

完成：

✅ Treasure

✅ Timer

✅ Joker

---

## Phase 4 上架

完成：

✅ Icon

✅ Screenshot

✅ Privacy

✅ TestFlight

---

# 最终Flutter工程规模预估

```
Screens:

10


Widgets:

40-60


Models:

10


Controllers:

6


Assets:

100左右


代码:

8000-12000行 Dart

```
# Solitaire Journey（暂定名）

## 接龙纸牌 App 游戏功能 & UI设计文档（Flutter开发版）

---

# 1. 游戏定位

## 游戏名称

**Solitaire Journey**

## 游戏类型

* Classic Solitaire（经典接龙）
* Adventure Puzzle（关卡冒险）
* Creative Solitaire Modes（创新玩法）

## 平台

* iOS App Store
* Android（后续）

## 技术方案

* Flutter + Dart
* 适合 Flutter 初学者开发
* 不使用复杂3D、不需要服务器
* 本地 JSON 数据管理关卡

---

# 2. 核心设计理念

区别普通 Solitaire：

传统：

> 打开 → 玩一局 → 结束

本游戏：

> 冒险地图 → 解锁关卡 → 收集奖励 → 解锁主题 → 挑战特殊玩法

类似：

* Candy Crush 的关卡体系
* Monument Valley 的章节体验
* Solitaire Grand Harvest 的成长机制

---

# 3. 游戏整体结构

```
App Start

      |
      ↓

Home 首页

      |
      ├── Classic Solitaire
      |
      ├── Adventure Levels
      |
      ├── Creative Modes
      |
      ├── Daily Challenge
      |
      └── Customize Theme


```

---

# 4. 页面UI设计

---

# A. 首页 Home Screen

## 目标

让用户快速开始游戏。

## UI结构

```
--------------------------------

      Solitaire Journey

          ✨


   [ Continue Level 3-2 ]



   🃏 Classic Solitaire


   ⭐ Creative Modes



   📅 Daily Challenge



-------------------------------

 Settings     Levels     Hint
 Undo         Theme


--------------------------------

```

## 元素

### 顶部

左：

金币

```
🪙 2450 +
```

右：

```
🔊 Sound

⚙ Settings
```

---

## 中间

Logo:

```
Solitaire
Journey
```

字体：

* 白色
* 金色阴影

背景：

纯绿色牌桌

颜色：

```
#0F4728

#185C35

#267344
```

---

# B. 游戏主界面 Game Screen

## 目标

保持经典接龙体验

UI:

```

Score       Time       Moves

1200        02:35       28



A     A     A     A


        Deck

        🂠



----------------


K♠
Q♥
J♣
10♦
9♠
8♥
7♣



----------------


Hint
Undo
New Deal
Theme


```

---

## 功能

### 卡牌操作

支持：

* 点击移动
* Drag & Drop
* 自动吸附
* 自动翻牌

Flutter实现：

```
GestureDetector

Draggable

DragTarget

AnimatedContainer

```

---

# C. 关卡系统 Level Map

## 核心卖点

类似 Candy Crush

UI:

```

Chapter 1

Beginner Road


 ⭐⭐⭐


      5


      |
      
      4 ⭐⭐⭐


      |

      3 ⭐⭐


      |

      2 🔒


      |

      1 ⭐⭐⭐



Chapter Reward

🎁


```

---

# 关卡数据

JSON:

```json
{
"id":1,
"chapter":"Beginner Road",
"level":3,
"stars":3,
"time":120,
"goal":"clear_all_cards"
}

```

---

# 关卡目标

普通：

```
Clear all cards
```

增加变化：

## Level任务类型

### 1. Clear Board

清空牌面

---

### 2. Time Challenge

```
Finish under 60 seconds

```

---

### 3. Limited Moves

```
Win under 40 moves

```

---

### 4. Collect Cards

```
Collect all hearts

```

---

### 5. Rescue

```
Free trapped cards

```

---

# D. Theme换肤系统

## 需求：

只换背景图片

不支持用户上传

---

## 页面

```

Customize


[Background]

[Card Back]

[Effects]




--------------------------------


Classic Green

Ocean Coast

Snow Cottage

Winter Train

Spring Meadow

Night Forest



--------------------------------


Preset Themes Only

```

---

## 内置图片

Assets:

```
assets/themes/


green.jpg

ocean.jpg

snow.jpg

forest.jpg

night.jpg

spring.jpg


```

Flutter:

```dart
List<String> themes=[

"green.jpg",

"ocean.jpg",

"snow.jpg"

];

```

---

# E. Creative Modes 创意模式

这是App Store差异化重点。

---

# Mode 1

# Treasure Hunt

## 玩法

隐藏宝箱。

规则：

完成组合：

↓

发现宝藏卡

UI:

```

Treasure Hunt


Find 3 hidden treasures


🎁 🎁 🎁


Start

```

---

# Mode 2

# Timed Rush

玩法：

倒计时挑战

例如：

```
60 Seconds


Score as much as possible


```

---

# Mode 3

# Joker Rescue

新增 Joker 卡。

规则：

Joker被锁住：

```
🃏 🔒


解除条件：

完成连续移动


```

---

# Mode 4

# Shadow Cards

隐藏卡牌

开始：

```

?
?
?


```

玩家记忆翻牌。

---

# Mode 5

# Locked Deck

特殊卡：

锁链卡

```

🔒 10♠


需要：

连续完成3次移动

```

---

# Mode 6

# One Draw Sprint

只有：

一次抽牌

难度增加。

---

# Creative Mode 页面

UI:

```

Creative Modes


[ Treasure Hunt ]

🎁

10 Levels



[ Timed Rush ]

⏱

8 Levels



[ Joker Rescue ]

🤡

12 Levels



[ Shadow Cards ]

?


10 Levels



[ Locked Deck ]

🔒

9 Levels


```

---

# 5. 游戏奖励系统

## Stars

每关：

```
⭐
⭐⭐
⭐⭐⭐

```

条件：

三星：

* 时间快
* 少移动
* 完美完成

---

## Coins

用途：

解锁：

* Theme
* Hint

---

# 6. Bottom Navigation

取消个人中心。

保留：

```

⚙ Settings

🗺 Levels

💡 Hint

↩ Undo

🎨 Theme


```

---

# 7. Flutter项目结构

推荐：

```
lib/


main.dart


screens/

 home_screen.dart

 game_screen.dart

 level_screen.dart

 theme_screen.dart

 creative_screen.dart



models/


 card_model.dart

 level_model.dart


widgets/


 playing_card.dart

 game_button.dart

 theme_card.dart


data/


levels.json


assets/


themes/

 cards/

 icons/


```

---

# 8. Flutter开发难度评级

| 功能          | 难度  |
| ----------- | --- |
| 主页          | ⭐   |
| 换背景         | ⭐   |
| 关卡地图        | ⭐⭐  |
| 普通接龙        | ⭐⭐⭐ |
| 动画          | ⭐⭐  |
| Creative模式  | ⭐⭐  |
| 存档          | ⭐   |
| App Store发布 | ⭐⭐  |

适合 Flutter 新手。

---

# 9. 第一版MVP（建议）

为了快速上架：

## V1

必须：

✅ Classic Solitaire

✅ 30关

✅ Level Map

✅ 6个背景主题

✅ 3个Creative Mode

暂时不要：

❌ 联机

❌ 排行榜

❌ 用户账号

❌ 自定义图片

---

# 10. App Store卖点描述

英文：

> Solitaire Journey brings classic solitaire into a relaxing adventure. Complete levels, unlock beautiful themes, and enjoy creative challenges including Treasure Hunt, Timed Rush, and Joker Rescue.

关键词：

```
Solitaire
Card Game
Puzzle
Brain Training
Relaxing
Offline Game
Daily Challenge

```

---

# 11. 推荐最终UI数量

需要设计：

1. Splash Screen
2. Home Screen
3. Level Map
4. Game Screen
5. Win Popup
6. Lose Popup
7. Theme Screen
8. Creative Modes List
9. Creative Mode Detail
10. Settings

共：

**10张UI页面即可完成完整App设计。**

这套设计可以直接作为 Flutter 开发 PRD + UI稿基础。
