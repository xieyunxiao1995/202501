/// 应用路由配置
///
/// 使用 GoRouter ^14.0.0 管理所有页面路由。
/// 通过 Riverpod Provider 暴露 GoRouter 实例，
/// 使用 ShellRoute 实现主布局（底部导航 + 内容区）。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'navigation_service.dart';
import 'route_guard.dart';
import 'route_observer.dart';
import 'route_paths.dart';

import '../../pages/general/general_detail_page.dart';
import '../../pages/general/general_list_page.dart';
import '../../pages/login_page.dart';
import '../../pages/maincity_page.dart';
import '../../pages/personal_page.dart';
import '../../pages/recruit_heroes_page.dart';
import '../../pages/battle/battle_page.dart';
import '../../pages/splash_page.dart';
import '../../pages/story_page.dart';
import '../../pages/story/story_chapter_page.dart';

import '../../data/models/general/general_model.dart';

import '../../pages/city/lord_mansion_page.dart';
import '../../pages/city/training_ground_page.dart';
import '../../pages/city/council_hall_page.dart';
import '../../pages/city/weapon_workshop_page.dart';
import '../../pages/city/stable_page.dart';
import '../../pages/city/tavern_page.dart';
import '../../pages/city/granary_page.dart';
import '../../pages/city/mint_page.dart';
import '../../pages/city/academy_page.dart';
import '../../pages/city/observatory_page.dart';
import '../../pages/city/arena_page.dart';

/// GoRouter Provider
///
/// 通过 Riverpod 管理路由实例，确保全局唯一。
/// 在 MaterialApp 中使用 `routerConfig` 参数传入。
///
/// ```dart
/// MaterialApp.router(routerConfig: ref.watch(appRouterProvider));
/// ```
final appRouterProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    navigatorKey: NavigationService.instance.navigatorKey,
    initialLocation: RoutePaths.splash,
    redirect: RouteGuard.guard,
    observers: [_GoRouterObserver()],
    routes: [
      // ==================== 独立页面（无Shell） ====================

      /// 闪屏页
      GoRoute(
        path: RoutePaths.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      /// 登录页
      GoRoute(
        path: RoutePaths.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      /// 更新页
      GoRoute(
        path: RoutePaths.update,
        name: 'update',
        builder: (context, state) => const _PlaceholderPage(title: '更新提示'),
      ),

      /// 服务器选择
      GoRoute(
        path: RoutePaths.serverSelect,
        name: 'serverSelect',
        builder: (context, state) => const _PlaceholderPage(title: '服务器选择'),
      ),

      /// 开场CG
      GoRoute(
        path: RoutePaths.openingCG,
        name: 'openingCG',
        builder: (context, state) => const _PlaceholderPage(title: '开场CG'),
      ),

      /// 新手教程
      GoRoute(
        path: RoutePaths.tutorial,
        name: 'tutorial',
        builder: (context, state) => const _PlaceholderPage(title: '新手教程'),
      ),

      // ==================== 战斗相关（无Shell，全屏） ====================

      /// 战斗结算
      GoRoute(
        path: RoutePaths.battleResult,
        name: 'battleResult',
        builder: (context, state) => const _PlaceholderPage(title: '战斗结算'),
      ),

      /// 战斗页面（4v4回合制卡牌战斗）
      GoRoute(
        path: RoutePaths.battle,
        name: 'battle',
        pageBuilder: (context, state) => _FadeTransitionPage(
          key: state.pageKey,
          child: BattlePage(heroes: state.extra as List<GeneralModel>),
        ),
      ),

      /// 匹配中
      GoRoute(
        path: RoutePaths.matching,
        name: 'matching',
        builder: (context, state) => const _PlaceholderPage(title: '匹配中'),
      ),

      /// 禁选阶段
      GoRoute(
        path: RoutePaths.banPick,
        name: 'banPick',
        builder: (context, state) => const _PlaceholderPage(title: '禁选阶段'),
      ),

      /// 招募动画
      GoRoute(
        path: RoutePaths.recruitAnimation,
        name: 'recruitAnimation',
        builder: (context, state) => const _PlaceholderPage(title: '招募动画'),
      ),

      /// 招募结果
      GoRoute(
        path: RoutePaths.recruitResult,
        name: 'recruitResult',
        builder: (context, state) => const _PlaceholderPage(title: '招募结果'),
      ),

      // ==================== 主布局 Shell ====================
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          // ---------- 主页 ----------
          GoRoute(
            path: RoutePaths.home,
            name: 'home',
            pageBuilder: (context, state) => _FadeTransitionPage(
              key: state.pageKey,
              child: const MainCityPage(),
            ),
          ),

          // ---------- 个人中心 ----------
          GoRoute(
            path: RoutePaths.personal,
            name: 'personal',
            pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
              key: state.pageKey,
              startRect: state.extra as Rect?,
              child: const PersonalPage(),
            ),
          ),

          // ---------- 武将 ----------
          GoRoute(
            path: RoutePaths.generalList,
            name: 'generalList',
            pageBuilder: (context, state) => _FadeTransitionPage(
              key: state.pageKey,
              child: const GeneralListPage(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                name: 'generalDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return GeneralDetailPage(generalId: id);
                },
                routes: [
                  GoRoute(
                    path: 'upgrade',
                    name: 'generalUpgrade',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '武将升级 #$id');
                    },
                  ),
                  GoRoute(
                    path: 'evolve',
                    name: 'generalEvolve',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '武将进化 #$id');
                    },
                  ),
                  GoRoute(
                    path: 'awake',
                    name: 'generalAwake',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '武将觉醒 #$id');
                    },
                  ),
                  GoRoute(
                    path: 'star-up',
                    name: 'generalStarUp',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '武将升星 #$id');
                    },
                  ),
                  GoRoute(
                    path: 'equipment',
                    name: 'equipment',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '武将装备 #$id');
                    },
                  ),
                  GoRoute(
                    path: 'weapon',
                    name: 'weapon',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '武将武器 #$id');
                    },
                  ),
                  GoRoute(
                    path: 'horse',
                    name: 'horse',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '武将坐骑 #$id');
                    },
                  ),
                  GoRoute(
                    path: 'skill',
                    name: 'skill',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '武将技能 #$id');
                    },
                  ),
                  GoRoute(
                    path: 'biography',
                    name: 'biography',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '武将传记 #$id');
                    },
                  ),
                ],
              ),
            ],
          ),

          // ---------- 阵容 ----------
          GoRoute(
            path: RoutePaths.lineup,
            name: 'lineup',
            builder: (context, state) => const _PlaceholderPage(title: '阵容编组'),
            routes: [
              GoRoute(
                path: 'formation',
                name: 'formation',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '阵法选择'),
              ),
              GoRoute(
                path: 'bond',
                name: 'bond',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '羁绊'),
              ),
              GoRoute(
                path: 'preset',
                name: 'lineupPreset',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '阵容预设'),
              ),
            ],
          ),

          // ---------- 关卡 ----------
          GoRoute(
            path: RoutePaths.chapterList,
            name: 'chapterList',
            builder: (context, state) => const _PlaceholderPage(title: '章节列表'),
            routes: [
              GoRoute(
                path: 'chapters/:chapterId',
                name: 'stageList',
                builder: (context, state) {
                  final chapterId = state.pathParameters['chapterId'] ?? '';
                  return _PlaceholderPage(title: '关卡列表 章节#$chapterId');
                },
                routes: [
                  GoRoute(
                    path: 'stages/:stageId',
                    name: 'stageDetail',
                    builder: (context, state) {
                      final chapterId = state.pathParameters['chapterId'] ?? '';
                      final stageId = state.pathParameters['stageId'] ?? '';
                      return _PlaceholderPage(
                        title: '关卡详情 章节#$chapterId 关卡#$stageId',
                      );
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'classic-battles/:id',
                name: 'classicBattle',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return _PlaceholderPage(title: '经典战役 #$id');
                },
              ),
              GoRoute(
                path: 'tower',
                name: 'tower',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '爬塔'),
              ),
              GoRoute(
                path: 'elite',
                name: 'eliteDungeon',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '精英副本'),
              ),
              GoRoute(
                path: 'resource',
                name: 'resourceDungeon',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '资源副本'),
              ),
            ],
          ),

          // ---------- 剧情 ----------
          GoRoute(
            path: RoutePaths.story,
            name: 'story',
            pageBuilder: (context, state) => _FadeTransitionPage(
              key: state.pageKey,
              child: const StoryPage(),
            ),
            routes: [
              GoRoute(
                path: 'chapter/:chapterIndex',
                name: 'storyChapter',
                pageBuilder: (context, state) {
                  final chapterIndex = int.tryParse(
                        state.pathParameters['chapterIndex'] ?? '0',
                      ) ??
                      0;
                  return _ExpandFromRectTransitionPage(
                    key: state.pageKey,
                    startRect: state.extra as Rect?,
                    child: StoryChapterPage(chapterIndex: chapterIndex),
                  );
                },
              ),
            ],
          ),

          // ---------- 城池 ----------
          GoRoute(
            path: '/city',
            name: 'city',
            // redirect: (context, state) => RoutePaths.lordMansion,
            builder: (context, state) => const MainCityPage(),
            routes: [
              // 主公府
              GoRoute(
                path: 'lord-mansion',
                name: 'lordMansion',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const LordMansionPage(),
                ),
              ),
              // 校场
              GoRoute(
                path: 'training-ground',
                name: 'trainingGround',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const TrainingGroundPage(),
                ),
              ),
              // 议事厅
              GoRoute(
                path: 'council-hall',
                name: 'councilHall',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const CouncilHallPage(),
                ),
              ),
              // 武器坊
              GoRoute(
                path: 'weapon-workshop',
                name: 'weaponWorkshop',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const WeaponWorkshopPage(),
                ),
              ),
              // 马厩
              GoRoute(
                path: 'stable',
                name: 'stable',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const StablePage(),
                ),
              ),
              // 酒馆
              GoRoute(
                path: 'tavern',
                name: 'tavern',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const TavernPage(),
                ),
              ),
              // 粮仓
              GoRoute(
                path: 'granary',
                name: 'granary',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const GranaryPage(),
                ),
              ),
              // 铸币司
              GoRoute(
                path: 'mint',
                name: 'mint',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const MintPage(),
                ),
              ),
              // 学堂
              GoRoute(
                path: 'academy',
                name: 'academy',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const AcademyPage(),
                ),
              ),
              // 观星台
              GoRoute(
                path: 'observatory',
                name: 'observatory',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const ObservatoryPage(),
                ),
              ),
              // 演武场
              GoRoute(
                path: 'arena',
                name: 'cityArena',
                pageBuilder: (context, state) => _ExpandFromRectTransitionPage(
                  key: state.pageKey,
                  startRect: state.extra as Rect?,
                  child: const ArenaPage(),
                ),
              ),
              // 建筑详情（:id 为建筑ID）
              GoRoute(
                path: 'buildings/:id',
                name: 'buildingDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return _PlaceholderPage(title: '建筑详情 #$id');
                },
                routes: [
                  GoRoute(
                    path: 'upgrade',
                    name: 'buildingUpgrade',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '建筑升级 #$id');
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'resources',
                name: 'resourceCollect',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '资源收取'),
              ),
              GoRoute(
                path: 'tech-tree',
                name: 'techTree',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '科技树'),
              ),
            ],
          ),

          // ---------- 招募 ----------
          GoRoute(
            path: RoutePaths.recruit,
            name: 'recruit',
            pageBuilder: (context, state) => _FadeTransitionPage(
              key: state.pageKey,
              child: const RecruitHeroesPage(),
            ),
            routes: [
              GoRoute(
                path: 'pool/:id',
                name: 'recruitPool',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return _PlaceholderPage(title: '招募池 #$id');
                },
              ),
              GoRoute(
                path: 'history',
                name: 'recruitHistory',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '招募历史'),
              ),
            ],
          ),

          // ---------- 商店 ----------
          GoRoute(
            path: RoutePaths.shop,
            name: 'shop',
            builder: (context, state) => const _PlaceholderPage(title: '商店'),
            routes: [
              GoRoute(
                path: 'recharge',
                name: 'recharge',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '充值'),
              ),
              GoRoute(
                path: 'monthly-card',
                name: 'monthlyCard',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '月卡'),
              ),
              GoRoute(
                path: 'battle-pass',
                name: 'battlePass',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '战令'),
              ),
              GoRoute(
                path: 'arena',
                name: 'arenaShop',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '竞技场商店'),
              ),
              GoRoute(
                path: 'kingdom',
                name: 'kingdomShop',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '国家商店'),
              ),
              GoRoute(
                path: 'alliance',
                name: 'allianceShop',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '联盟商店'),
              ),
            ],
          ),

          // ---------- 背包 ----------
          GoRoute(
            path: RoutePaths.bag,
            name: 'bag',
            builder: (context, state) => const _PlaceholderPage(title: '背包'),
            routes: [
              GoRoute(
                path: 'items/:id',
                name: 'itemDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return _PlaceholderPage(title: '物品详情 #$id');
                },
              ),
            ],
          ),

          // ---------- PVP ----------
          GoRoute(
            path: '/pvp',
            name: 'pvp',
            redirect: (context, state) => RoutePaths.arena,
            routes: [
              GoRoute(
                path: 'arena',
                name: 'arena',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '竞技场'),
              ),
              GoRoute(
                path: 'peak-arena',
                name: 'peakArena',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '巅峰竞技场'),
              ),
              GoRoute(
                path: 'replay/:id',
                name: 'pvpReplay',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return _PlaceholderPage(title: 'PVP回放 #$id');
                },
              ),
            ],
          ),

          // ---------- 国战 ----------
          GoRoute(
            path: '/kingdom-war',
            name: 'kingdomWar',
            redirect: (context, state) => RoutePaths.kingdomSelect,
            routes: [
              GoRoute(
                path: 'select',
                name: 'kingdomSelect',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '国家选择'),
              ),
              GoRoute(
                path: 'map',
                name: 'kingdomMap',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '国战地图'),
              ),
              GoRoute(
                path: 'cities/:id',
                name: 'cityNode',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return _PlaceholderPage(title: '城池节点 #$id');
                },
              ),
              GoRoute(
                path: 'attack/:id',
                name: 'attackCity',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return _PlaceholderPage(title: '攻城战 #$id');
                },
              ),
              GoRoute(
                path: 'tasks',
                name: 'kingdomTask',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '国战任务'),
              ),
              GoRoute(
                path: 'rank',
                name: 'kingdomRank',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '国战排行'),
              ),
              GoRoute(
                path: 'rewards',
                name: 'kingdomReward',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '国战奖励'),
              ),
            ],
          ),

          // ---------- 社交 ----------
          GoRoute(
            path: '/social',
            name: 'social',
            redirect: (context, state) => RoutePaths.friend,
            routes: [
              GoRoute(
                path: 'friends',
                name: 'friend',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '好友列表'),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: 'friendDetail',
                    builder: (context, state) {
                      final id = state.pathParameters['id'] ?? '';
                      return _PlaceholderPage(title: '好友详情 #$id');
                    },
                  ),
                ],
              ),
              GoRoute(
                path: 'alliance',
                name: 'alliance',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '联盟'),
                routes: [
                  GoRoute(
                    path: 'battle',
                    name: 'allianceBattle',
                    builder: (context, state) =>
                        const _PlaceholderPage(title: '联盟战'),
                  ),
                  GoRoute(
                    path: 'members',
                    name: 'allianceMember',
                    builder: (context, state) =>
                        const _PlaceholderPage(title: '联盟成员'),
                  ),
                  GoRoute(
                    path: 'dungeon',
                    name: 'allianceDungeon',
                    builder: (context, state) =>
                        const _PlaceholderPage(title: '联盟副本'),
                  ),
                ],
              ),
              GoRoute(
                path: 'chat',
                name: 'chat',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '聊天'),
              ),
              GoRoute(
                path: 'mail',
                name: 'mail',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '邮件'),
              ),
            ],
          ),

          // ---------- 任务 ----------
          GoRoute(
            path: '/quests',
            name: 'quests',
            redirect: (context, state) => RoutePaths.dailyQuest,
            routes: [
              GoRoute(
                path: 'daily',
                name: 'dailyQuest',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '日常任务'),
              ),
              GoRoute(
                path: 'weekly',
                name: 'weeklyQuest',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '周常任务'),
              ),
              GoRoute(
                path: 'achievements',
                name: 'achievement',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '成就'),
              ),
              GoRoute(
                path: 'battle-pass',
                name: 'battlePassProgress',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '战令进度'),
              ),
            ],
          ),

          // ---------- 活动 ----------
          GoRoute(
            path: RoutePaths.activityList,
            name: 'activityList',
            builder: (context, state) => const _PlaceholderPage(title: '活动列表'),
            routes: [
              GoRoute(
                path: ':id',
                name: 'activityDetail',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return _PlaceholderPage(title: '活动详情 #$id');
                },
              ),
              GoRoute(
                path: 'festival/:id',
                name: 'festivalActivity',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return _PlaceholderPage(title: '节日活动 #$id');
                },
              ),
              GoRoute(
                path: 'limited/:id',
                name: 'limitedEvent',
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return _PlaceholderPage(title: '限时活动 #$id');
                },
              ),
            ],
          ),

          // ---------- 其他功能 ----------
          GoRoute(
            path: RoutePaths.biographyCollection,
            name: 'biographyCollection',
            builder: (context, state) => const _PlaceholderPage(title: '传记收集'),
          ),

          GoRoute(
            path: RoutePaths.divination,
            name: 'divination',
            builder: (context, state) => const _PlaceholderPage(title: '占卜'),
          ),

          // ---------- 排行榜 ----------
          GoRoute(
            path: RoutePaths.rank,
            name: 'rank',
            builder: (context, state) => const _PlaceholderPage(title: '排行榜'),
            routes: [
              GoRoute(
                path: 'power',
                name: 'powerRank',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '战力排行'),
              ),
              GoRoute(
                path: 'arena',
                name: 'arenaRank',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '竞技场排行'),
              ),
              GoRoute(
                path: 'tower',
                name: 'towerRank',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '爬塔排行'),
              ),
              GoRoute(
                path: 'alliance',
                name: 'allianceRank',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '联盟排行'),
              ),
              GoRoute(
                path: 'title',
                name: 'titleRank',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '称号排行'),
              ),
            ],
          ),

          // ---------- 设置 ----------
          GoRoute(
            path: RoutePaths.settings,
            name: 'settings',
            pageBuilder: (context, state) => _ScaleTransitionPage(
              key: state.pageKey,
              child: const _PlaceholderPage(title: '设置'),
            ),
            routes: [
              GoRoute(
                path: 'account',
                name: 'account',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '账号设置'),
              ),
              GoRoute(
                path: 'audio',
                name: 'audioSettings',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '音频设置'),
              ),
              GoRoute(
                path: 'graphics',
                name: 'graphicsSettings',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '画面设置'),
              ),
              GoRoute(
                path: 'about',
                name: 'about',
                builder: (context, state) =>
                    const _PlaceholderPage(title: '关于'),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  // 将 router 实例注册到 NavigationService
  NavigationService.instance.setRouter(router);

  return router;
});

// ==================== GoRouter 观察者适配 ====================

/// GoRouter 路由观察者适配器
///
/// 将 GoRouter 的路由变化事件转发给 [AppRouteObserver]。
/// 继承 [NavigatorObserver]，因为 GoRouter 的 observers 参数
/// 接受的是 NavigatorObserver 列表。
class _GoRouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppRouteObserver.instance.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    AppRouteObserver.instance.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    AppRouteObserver.instance.didReplace(
      newRoute: newRoute,
      oldRoute: oldRoute,
    );
  }
}

// ==================== 主布局 Shell ====================

/// 从中间弹出的缩放过渡动画页面
///
/// 用于底部导航栏页面切换时产生从屏幕中央弹出的效果。
class _ScaleTransitionPage extends CustomTransitionPage<void> {
  _ScaleTransitionPage({required super.key, required super.child})
    : super(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return ScaleTransition(
            scale: Tween<double>(begin: 0.85, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            ),
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      );
}

/// 淡入过渡动画页面
///
/// 页面以纯淡入效果出现，无缩放或位移。
/// 用于底部导航栏"招募"等页面的切换效果。
class _FadeTransitionPage extends CustomTransitionPage<void> {
  _FadeTransitionPage({required super.key, required super.child})
    : super(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 250),
        reverseTransitionDuration: const Duration(milliseconds: 180),
      );
}

/// 从按钮区域弹出的缩放过渡动画页面
///
/// 页面从用户点击的按钮位置展开至全屏，
/// 用于城池建筑入口的页面切换效果。
class _ExpandFromRectTransitionPage extends CustomTransitionPage<void> {
  _ExpandFromRectTransitionPage({
    required super.key,
    required super.child,
    Rect? startRect,
  }) : super(
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           final screenSize = MediaQuery.of(context).size;
           final rect = startRect;

           // 计算缩放原点（相对于屏幕的 Alignment）
           final origin = rect != null
               ? Alignment(
                   (rect.center.dx / screenSize.width) * 2 - 1,
                   (rect.center.dy / screenSize.height) * 2 - 1,
                 )
               : Alignment.center;

           return ScaleTransition(
             scale: Tween<double>(begin: 0.01, end: 1.0).animate(
               CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
             ),
             alignment: origin,
             child: FadeTransition(
               opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                 CurvedAnimation(
                   parent: animation,
                   curve: Interval(0.0, 0.4, curve: Curves.easeOut),
                 ),
               ),
               child: child,
             ),
           );
         },
         transitionDuration: const Duration(milliseconds: 350),
         reverseTransitionDuration: const Duration(milliseconds: 250),
       );
}

/// 主布局壳组件
///
/// 包含底部导航栏和内容区域。
/// ShellRoute 的子路由将作为 [child] 参数传入内容区。
class MainShell extends StatelessWidget {
  const MainShell({super.key, required this.child});

  /// 子路由内容
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // 移除底部安全区域，缩小导航栏高度
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: Scaffold(body: child, bottomNavigationBar: const _BottomNavBar()),
    );
  }
}

/// 底部导航栏
///
/// 五个主要入口：主页、武将、城池、招募、更多。
class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    final currentIndex = _calculateSelectedIndex(context);

    return NavigationBar(
      height: 60,
      selectedIndex: currentIndex,
      onDestinationSelected: (index) => _onItemTapped(context, index),
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: '主页',
        ),
        NavigationDestination(
          icon: Icon(Icons.people_outline),
          selectedIcon: Icon(Icons.people),
          label: '武将',
        ),
        NavigationDestination(
          icon: Icon(Icons.location_city_outlined),
          selectedIcon: Icon(Icons.location_city),
          label: '剧情',
        ),
        NavigationDestination(
          icon: Icon(Icons.casino_outlined),
          selectedIcon: Icon(Icons.casino),
          label: '战斗',
        ),
        NavigationDestination(
          icon: Icon(Icons.more_horiz),
          selectedIcon: Icon(Icons.more_horiz),
          label: '背包',
        ),
      ],
    );
  }

  /// 根据当前路由计算底部导航的选中索引
  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location == RoutePaths.home) return 0;
    if (location.startsWith('/generals')) return 1;
    if (location.startsWith('/story')) return 2;
    if (location.startsWith('/recruit')) return 3;
    return 4;
  }

  /// 底部导航项点击处理
  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        GoRouter.of(context).go(RoutePaths.home);
      case 1:
        GoRouter.of(context).go(RoutePaths.generalList);
      case 2:
        GoRouter.of(context).go(RoutePaths.story);
      case 3:
        GoRouter.of(context).go(RoutePaths.recruit);
      case 4:
        GoRouter.of(context).go(RoutePaths.settings);
    }
  }
}

// ==================== 占位页面 ====================

/// 占位页面
///
/// 在正式页面实现前用作路由目标的占位组件。
/// 仅展示页面标题，便于调试路由配置。
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  /// 页面标题
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              '页面开发中...',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
