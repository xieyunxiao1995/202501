/// 路由路径常量定义
///
/// 集中管理所有页面路由路径，便于维护和统一引用。
/// 路径中含 `:param` 的为动态参数路径。
library;

/// 所有路由路径常量
///
/// 命名规范：使用小写字母和短横线分隔（kebab-case）。
/// 子页面路径在父页面路径基础上扩展。
class RoutePaths {
  RoutePaths._();

  // ==================== 启动与登录 ====================

  /// 闪屏页
  static const String splash = '/splash';

  /// 登录页
  static const String login = '/login';

  /// 更新页（热更/强更提示）
  static const String update = '/update';

  /// 服务器选择页
  static const String serverSelect = '/server-select';

  // ==================== 主页 ====================

  /// 主页
  static const String home = '/home';

  /// 个人中心
  static const String personal = '/personal';

  // ==================== 剧情 ====================

  /// 剧情主界面
  static const String story = '/story';

  // ==================== 武将 ====================

  /// 武将列表
  static const String generalList = '/generals';

  /// 武将详情（:id 为武将ID）
  static const String generalDetail = '/generals/:id';

  /// 武将升级
  static const String generalUpgrade = '/generals/:id/upgrade';

  /// 武将进化
  static const String generalEvolve = '/generals/:id/evolve';

  /// 武将觉醒
  static const String generalAwake = '/generals/:id/awake';

  /// 武将升星
  static const String generalStarUp = '/generals/:id/star-up';

  /// 武将装备
  static const String equipment = '/generals/:id/equipment';

  /// 武将武器
  static const String weapon = '/generals/:id/weapon';

  /// 武将坐骑
  static const String horse = '/generals/:id/horse';

  /// 武将技能
  static const String skill = '/generals/:id/skill';

  /// 武将传记
  static const String biography = '/generals/:id/biography';

  // ==================== 阵容 ====================

  /// 阵容编组
  static const String lineup = '/lineup';

  /// 阵法选择
  static const String formation = '/lineup/formation';

  /// 缘分/羁绊
  static const String bond = '/lineup/bond';

  /// 阵容预设
  static const String lineupPreset = '/lineup/preset';

  // ==================== 关卡 ====================

  /// 章节列表
  static const String chapterList = '/stages';

  /// 某章节的关卡列表（:chapterId 为章节ID）
  static const String stageList = '/stages/chapters/:chapterId';

  /// 关卡详情（:stageId 为关卡ID）
  static const String stageDetail =
      '/stages/chapters/:chapterId/stages/:stageId';

  /// 经典战役
  static const String classicBattle = '/stages/classic-battles/:id';

  /// 爬塔
  static const String tower = '/stages/tower';

  /// 精英副本
  static const String eliteDungeon = '/stages/elite';

  /// 资源副本
  static const String resourceDungeon = '/stages/resource';

  // ==================== 战斗 ====================

  /// 战斗结算
  static const String battleResult = '/battle/result';

  // ==================== 城池 ====================

  /// 城池主界面
  static const String city = '/city';

  /// 主公府
  static const String lordMansion = '/city/lord-mansion';

  /// 校场
  static const String trainingGround = '/city/training-ground';

  /// 议事厅
  static const String councilHall = '/city/council-hall';

  /// 武器坊
  static const String weaponWorkshop = '/city/weapon-workshop';

  /// 马厩
  static const String stable = '/city/stable';

  /// 酒馆
  static const String tavern = '/city/tavern';

  /// 粮仓
  static const String granary = '/city/granary';

  /// 铸币司
  static const String mint = '/city/mint';

  /// 学堂
  static const String academy = '/city/academy';

  /// 观星台
  static const String observatory = '/city/observatory';

  /// 演武场
  static const String cityArena = '/city/arena';

  /// 建筑详情（:id 为建筑ID）
  static const String buildingDetail = '/city/buildings/:id';

  /// 建筑升级
  static const String buildingUpgrade = '/city/buildings/:id/upgrade';

  /// 资源收取
  static const String resourceCollect = '/city/resources';

  /// 科技树
  static const String techTree = '/city/tech-tree';

  // ==================== 招募 ====================

  /// 招募主页
  static const String recruit = '/recruit';

  /// 招募池（:id 为池子ID）
  static const String recruitPool = '/recruit/pool/:id';

  /// 招募动画
  static const String recruitAnimation = '/recruit/animation';

  /// 招募结果
  static const String recruitResult = '/recruit/result';

  /// 招募历史
  static const String recruitHistory = '/recruit/history';

  // ==================== 商店 ====================

  /// 商店主页
  static const String shop = '/shop';

  /// 充值
  static const String recharge = '/shop/recharge';

  /// 月卡
  static const String monthlyCard = '/shop/monthly-card';

  /// 战令
  static const String battlePass = '/shop/battle-pass';

  /// 竞技场商店
  static const String arenaShop = '/shop/arena';

  /// 国家商店
  static const String kingdomShop = '/shop/kingdom';

  /// 联盟商店
  static const String allianceShop = '/shop/alliance';

  // ==================== 背包 ====================

  /// 背包
  static const String bag = '/bag';

  /// 物品详情（:id 为物品ID）
  static const String itemDetail = '/bag/items/:id';

  // ==================== PVP ====================

  /// 竞技场
  static const String arena = '/pvp/arena';

  /// 巅峰竞技场
  static const String peakArena = '/pvp/peak-arena';

  /// 匹配中
  static const String matching = '/pvp/matching';

  /// 禁选阶段
  static const String banPick = '/pvp/ban-pick';

  /// PVP回放（:id 为回放ID）
  static const String pvpReplay = '/pvp/replay/:id';

  // ==================== 国战 ====================

  /// 国家选择
  static const String kingdomSelect = '/kingdom-war/select';

  /// 国战地图
  static const String kingdomMap = '/kingdom-war/map';

  /// 城池节点（:id 为城池ID）
  static const String cityNode = '/kingdom-war/cities/:id';

  /// 攻城战（:id 为城池ID）
  static const String attackCity = '/kingdom-war/attack/:id';

  /// 国战任务
  static const String kingdomTask = '/kingdom-war/tasks';

  /// 国战排行
  static const String kingdomRank = '/kingdom-war/rank';

  /// 国战奖励
  static const String kingdomReward = '/kingdom-war/rewards';

  // ==================== 社交 ====================

  /// 好友列表
  static const String friend = '/social/friends';

  /// 好友详情（:id 为好友ID）
  static const String friendDetail = '/social/friends/:id';

  /// 联盟
  static const String alliance = '/social/alliance';

  /// 联盟战
  static const String allianceBattle = '/social/alliance/battle';

  /// 联盟成员
  static const String allianceMember = '/social/alliance/members';

  /// 联盟副本
  static const String allianceDungeon = '/social/alliance/dungeon';

  /// 聊天
  static const String chat = '/social/chat';

  /// 邮件
  static const String mail = '/social/mail';

  // ==================== 任务 ====================

  /// 日常任务
  static const String dailyQuest = '/quests/daily';

  /// 周常任务
  static const String weeklyQuest = '/quests/weekly';

  /// 成就
  static const String achievement = '/quests/achievements';

  /// 战令进度
  static const String battlePassProgress = '/quests/battle-pass';

  // ==================== 活动 ====================

  /// 活动列表
  static const String activityList = '/activities';

  /// 活动详情（:id 为活动ID）
  static const String activityDetail = '/activities/:id';

  /// 节日活动（:id 为活动ID）
  static const String festivalActivity = '/activities/festival/:id';

  /// 限时活动（:id 为活动ID）
  static const String limitedEvent = '/activities/limited/:id';

  // ==================== 其他 ====================

  /// 传记收集
  static const String biographyCollection = '/biography';

  /// 占卜
  static const String divination = '/divination';

  /// 排行榜入口
  static const String rank = '/rank';

  /// 战力排行
  static const String powerRank = '/rank/power';

  /// 竞技场排行
  static const String arenaRank = '/rank/arena';

  /// 爬塔排行
  static const String towerRank = '/rank/tower';

  /// 联盟排行
  static const String allianceRank = '/rank/alliance';

  /// 称号排行
  static const String titleRank = '/rank/title';

  // ==================== 设置 ====================

  /// 设置主页
  static const String settings = '/settings';

  /// 账号设置
  static const String account = '/settings/account';

  /// 音频设置
  static const String audioSettings = '/settings/audio';

  /// 画面设置
  static const String graphicsSettings = '/settings/graphics';

  /// 关于
  static const String about = '/settings/about';

  // ==================== 新手引导 ====================

  /// 开场CG
  static const String openingCG = '/guide/opening';

  /// 新手教程
  static const String tutorial = '/guide/tutorial';
}
