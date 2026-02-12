import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_service.dart';
import '../../models/skill.dart';
import '../../utils/constants.dart';

class SkillScreen extends StatelessWidget {
  final GameService gameService;

  const SkillScreen({super.key, required this.gameService});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: gameService,
      builder: (context, child) {
        final player = gameService.player;
        if (player == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));

        final isSmallScreen = MediaQuery.of(context).size.width < 380;

        return Scaffold(
          backgroundColor: AppColors.bgPaper,
          appBar: AppBar(
            backgroundColor: AppColors.bgPaper,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.inkBlack),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              '道法修行',
              style: GoogleFonts.maShanZheng(
                fontSize: isSmallScreen ? 24 : 28,
                color: AppColors.inkBlack,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.inkBlack.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.inkBlack.withOpacity(0.1)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.water_drop, size: 16, color: AppColors.inkBlack),
                    const SizedBox(width: 4),
                    Text(
                      '${player.ink}',
                      style: GoogleFonts.maShanZheng(fontSize: 18, color: AppColors.inkBlack),
                    ),
                  ],
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              // Background Pattern
              Positioned.fill(
                child: Opacity(
                  opacity: 0.05,
                  child: Image.network(
                    'https://www.transparenttextures.com/patterns/wood-pattern.png',
                    repeat: ImageRepeat.repeat,
                    errorBuilder: (c, e, s) => Container(color: AppColors.woodLight),
                  ),
                ),
              ),
              
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: player.skills.length,
                itemBuilder: (context, index) {
                  final skill = player.skills[index];
                  return _buildSkillCard(context, skill, player.ink);
                },
              ),
              
              if (player.skills.isEmpty)
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.auto_fix_off_outlined, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        '暂无功法',
                        style: GoogleFonts.maShanZheng(fontSize: 24, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '请尝试重启游戏以领悟神通',
                        style: GoogleFonts.notoSerifSc(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSkillCard(BuildContext context, Skill skill, int playerInk) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 380;
    final bool canUpgrade = !skill.isMaxLevel && playerInk >= skill.upgradeCost;
    final Color themeColor = _getSkillColor(skill.statKey);

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.woodDark.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          // Background Character
          Positioned(
            right: -20,
            bottom: -20,
            child: Opacity(
              opacity: 0.05,
              child: Text(
                skill.name.substring(0, 1),
                style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 100 : 120, color: themeColor),
              ),
            ),
          ),
          
          Padding(
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(color: themeColor.withOpacity(0.5)),
                      ),
                      child: Icon(_getSkillIcon(skill.statKey), color: themeColor, size: isSmallScreen ? 20 : 24),
                    ),
                    SizedBox(width: isSmallScreen ? 12 : 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            skill.name,
                            style: GoogleFonts.maShanZheng(
                              fontSize: isSmallScreen ? 18 : 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.inkBlack,
                            ),
                          ),
                          Text(
                            skill.description,
                            style: GoogleFonts.notoSerifSc(
                              fontSize: isSmallScreen ? 10 : 12,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.woodLight.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Lv.${skill.level}',
                        style: GoogleFonts.notoSerifSc(
                          fontSize: isSmallScreen ? 12 : 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.woodDark,
                        ),
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: isSmallScreen ? 12 : 16),
                const Divider(height: 1),
                SizedBox(height: isSmallScreen ? 12 : 16),

                // Stats Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatChange(
                      '当前效果',
                      '${skill.currentValue}',
                      themeColor,
                      isSmallScreen,
                    ),
                    Icon(Icons.arrow_forward, color: Colors.grey, size: isSmallScreen ? 14 : 16),
                    skill.isMaxLevel
                        ? Text(
                            '已臻化境',
                            style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 16 : 18, color: Colors.grey),
                          )
                        : _buildStatChange(
                            '下级效果',
                            '${skill.nextValue}',
                            Colors.green,
                            isSmallScreen,
                            showPlus: true,
                          ),
                  ],
                ),

                SizedBox(height: isSmallScreen ? 16 : 20),

                // Upgrade Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: canUpgrade
                        ? () {
                            final success = gameService.upgradeSkill(skill);
                            if (success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('修行成功！${skill.name} 提升至 Lv.${skill.level + 1}'),
                                  backgroundColor: themeColor,
                                ),
                              );
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 10 : 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: skill.isMaxLevel
                        ? const Text('已满级')
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('修炼消耗 ', style: TextStyle(fontSize: isSmallScreen ? 12 : 14)),
                              Icon(Icons.water_drop, size: isSmallScreen ? 14 : 16, color: Colors.white70),
                              Text(' ${skill.upgradeCost}', style: TextStyle(fontSize: isSmallScreen ? 12 : 14)),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChange(String label, String value, Color color, bool isSmallScreen, {bool showPlus = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 10 : 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (showPlus)
              Icon(Icons.arrow_upward, size: isSmallScreen ? 10 : 12, color: color),
            Text(
              value,
              style: GoogleFonts.notoSerifSc(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Color _getSkillColor(String statKey) {
    switch (statKey) {
      case 'attack':
        return AppColors.inkRed;
      case 'defense':
        return const Color(0xFF2C3E50); // Dark Blue/Black
      case 'speed':
        return const Color(0xFF95A5A6); // Silver/Grey
      case 'maxInk':
        return Colors.teal;
      default:
        return AppColors.inkBlack;
    }
  }

  IconData _getSkillIcon(String statKey) {
    switch (statKey) {
      case 'attack':
        return Icons.local_fire_department_outlined;
      case 'defense':
        return Icons.shield_outlined;
      case 'speed':
        return Icons.bolt_outlined;
      case 'maxInk':
        return Icons.water_drop_outlined;
      default:
        return Icons.auto_awesome;
    }
  }
}
