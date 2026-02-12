import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';
import '../widgets/background_scaffold.dart'; // Import BackgroundScaffold
import 'map_selection_screen.dart';
import 'compendium_screen.dart';
import 'shop_screen.dart';
import 'task_screen.dart';
import 'inventory_screen.dart';
import 'settings_screen.dart';
import 'skill_screen.dart';
import 'summon_screen.dart';
import 'contract_screen.dart';
import 'daily_check_in_screen.dart';

class HubScreen extends StatelessWidget {
  final GameService gameService;

  const HubScreen({super.key, required this.gameService});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: gameService,
      builder: (context, child) {
        final player = gameService.player;
        if (player == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 380;
        final isTablet = screenWidth > 600.0;

        return BackgroundScaffold(
          backgroundImage: AppAssets.bgMistyBambooForest,
          body: SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: EdgeInsets.all(
                    isSmallScreen ? 16.0 : (isTablet ? 32.0 : 24.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '墨室',
                            style: Theme.of(context).textTheme.displaySmall
                                ?.copyWith(
                                  fontSize: isSmallScreen
                                      ? 32
                                      : (isTablet ? 48 : null),
                                ),
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          // Level Display
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Lv.${player.level}',
                                style: GoogleFonts.maShanZheng(
                                  fontSize: isSmallScreen
                                      ? 18
                                      : (isTablet ? 24 : 20),
                                  color: AppColors.inkBlack,
                                ),
                              ),
                              SizedBox(width: isTablet ? 12 : 8),
                              SizedBox(
                                width: isSmallScreen
                                    ? 60
                                    : (isTablet ? 120 : 80),
                                height: isTablet ? 6 : 4,
                                child: LinearProgressIndicator(
                                  value: player.currentExp / player.maxExp,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: const AlwaysStoppedAnimation(
                                    AppColors.inkRed,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          Row(
                            children: [
                              _StatBadge(
                                label: '理智',
                                value: '${player.sanity}/${player.maxSanity}',
                                isSmallScreen: isSmallScreen,
                                isTablet: isTablet,
                              ),
                              SizedBox(width: isTablet ? 24 : 16),
                              _StatBadge(
                                label: '墨韵',
                                value: '${player.ink}/${player.maxInk}',
                                isSmallScreen: isSmallScreen,
                                isTablet: isTablet,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.inkBlack),
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            child: Text(
                              '庚午',
                              style: TextStyle(fontSize: isTablet ? 18 : 14),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.inkBlack),
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            child: IconButton(
                              iconSize: isTablet ? 32 : 24,
                              icon: const Icon(
                                Icons.settings_outlined,
                                color: AppColors.inkBlack,
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SettingsScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Central Menu Area
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Expedition (Main)
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => MapSelectionScreen(
                                    gameService: gameService,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              width: isSmallScreen
                                  ? 240
                                  : (isTablet ? 400 : 280),
                              height: isSmallScreen
                                  ? 140
                                  : (isTablet ? 220 : 160),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF3EFE6),
                                border: const Border.symmetric(
                                  horizontal: BorderSide(
                                    color: AppColors.woodDark,
                                    width: 6,
                                  ),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    '山海',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          fontSize: isSmallScreen
                                              ? 60
                                              : (isTablet ? 120 : 80),
                                          color: Colors.black.withValues(
                                            alpha: 0.05,
                                          ),
                                        ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '出征',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displayMedium
                                            ?.copyWith(
                                              color: AppColors.inkBlack,
                                              fontWeight: FontWeight.bold,
                                              fontSize: isSmallScreen
                                                  ? 36
                                                  : (isTablet ? 56 : null),
                                            ),
                                      ),
                                      Container(
                                        height: 2,
                                        width: isTablet ? 60 : 40,
                                        color: AppColors.inkRed,
                                        margin: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                      ),
                                      Text(
                                        '踏破虚空',
                                        style: TextStyle(
                                          letterSpacing: 4,
                                          color: AppColors.woodLight,
                                          fontSize: isTablet ? 18 : 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: isTablet ? 50 : 30),

                          // Secondary Menu Grid
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final cardSize = isSmallScreen
                                  ? 100.0
                                  : (isTablet ? 160.0 : 130.0);
                              final spacing = isSmallScreen
                                  ? 12.0
                                  : (isTablet ? 32.0 : 20.0);

                              return Wrap(
                                spacing: spacing,
                                runSpacing: spacing,
                                alignment: WrapAlignment.center,
                                children: [
                                  _buildHubCard(
                                    context,
                                    '签到',
                                    '日省',
                                    Icons.calendar_today_outlined,
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const DailyCheckInScreen(),
                                      ),
                                    ),
                                    size: cardSize,
                                  ),
                                  _buildHubCard(
                                    context,
                                    '行囊',
                                    '万象',
                                    Icons.backpack_outlined,
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => InventoryScreen(
                                          gameService: gameService,
                                        ),
                                      ),
                                    ),
                                    size: cardSize,
                                  ),
                                  _buildHubCard(
                                    context,
                                    '商店',
                                    '奇珍',
                                    Icons.storefront_outlined,
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ShopScreen(
                                          gameService: gameService,
                                        ),
                                      ),
                                    ),
                                    size: cardSize,
                                  ),
                                  _buildHubCard(
                                    context,
                                    '图鉴',
                                    '博古',
                                    Icons.menu_book_outlined,
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const CompendiumScreen(),
                                      ),
                                    ),
                                    size: cardSize,
                                  ),
                                  _buildHubCard(
                                    context,
                                    '任务',
                                    '天道',
                                    Icons.assignment_outlined,
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TaskScreen(
                                          gameService: gameService,
                                        ),
                                      ),
                                    ),
                                    size: cardSize,
                                  ),
                                  _buildHubCard(
                                    context,
                                    '功法',
                                    '神通',
                                    Icons.auto_fix_high_outlined,
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SkillScreen(
                                          gameService: gameService,
                                        ),
                                      ),
                                    ),
                                    size: cardSize,
                                  ),
                                  _buildHubCard(
                                    context,
                                    '千抽',
                                    '祈愿',
                                    Icons.all_inclusive,
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => SummonScreen(
                                          gameService: gameService,
                                        ),
                                      ),
                                    ),
                                    size: cardSize,
                                  ),
                                  _buildHubCard(
                                    context,
                                    '契约',
                                    '神兽',
                                    Icons.pets,
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ContractScreen(
                                          gameService: gameService,
                                        ),
                                      ),
                                    ),
                                    size: cardSize,
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHubCard(
    BuildContext context,
    String title,
    String bgText,
    IconData icon,
    VoidCallback onTap, {
    double size = 130.0,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFFF3EFE6),
          border: Border.all(color: AppColors.woodDark, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: -10,
              bottom: -10,
              child: Text(
                bgText,
                style: GoogleFonts.maShanZheng(
                  fontSize: size * 0.46, // Dynamic font size
                  color: Colors.black.withValues(alpha: 0.03),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.inkBlack, size: size * 0.25),
                SizedBox(height: size * 0.06),
                Text(
                  title,
                  style: GoogleFonts.maShanZheng(
                    fontSize: size * 0.17,
                    color: AppColors.inkBlack,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final String label;
  final String value;
  final bool isSmallScreen;
  final bool isTablet;

  const _StatBadge({
    required this.label,
    required this.value,
    required this.isSmallScreen,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: isTablet ? 12 : 8,
          height: isTablet ? 12 : 8,
          decoration: const BoxDecoration(
            color: AppColors.woodDark,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: isTablet ? 8 : 4),
        Text(
          label,
          style: GoogleFonts.notoSerifSc(
            color: Colors.grey,
            fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14),
          ),
        ),
        SizedBox(width: isTablet ? 8 : 4),
        Text(
          value,
          style: GoogleFonts.maShanZheng(
            fontSize: isSmallScreen ? 16 : (isTablet ? 22 : 18),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
