import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/data.dart';
import '../theme/theme.dart';
import 'ai_stylist_chat_page.dart';
import 'style_test_page.dart';
import '../utils/responsive_helper.dart';

class StylistPage extends StatefulWidget {
  const StylistPage({super.key});

  @override
  State<StylistPage> createState() => _StylistPageState();
}

class _StylistPageState extends State<StylistPage> {
  String _selectedScene = '通勤';

  final List<Map<String, dynamic>> _scenes = [
    {'icon': Icons.commute_rounded, 'label': '通勤', 'active': true},
    {'icon': Icons.favorite_rounded, 'label': '约会', 'active': false},
    {'icon': Icons.fitness_center_rounded, 'label': '健身', 'active': false},
    {'icon': Icons.home_rounded, 'label': '居家', 'active': false},
    {'icon': Icons.business_center_rounded, 'label': '工作', 'active': false},
    {'icon': Icons.nightlife_rounded, 'label': '派对', 'active': false},
  ];

  final Map<String, List<Map<String, String>>> _sceneOutfitTemplates = {
    '通勤': [
      {
        'desc': '日常通勤的轻松时尚。舒适又不失精致。',
        'img': 'assets/role1.png',
      },
      {
        'desc': '应对多变天气的叠穿风格。时尚与实用兼具。',
        'img': 'assets/role2.png',
      },
      {
        'desc': '极简通勤风。干净利落，气场十足。',
        'img': 'assets/role3.png',
      },
    ],
    '约会': [
      {
        'desc': '浪漫优雅，引人注目。自信是最好的配饰。',
        'img': 'assets/role4.png',
      },
      {
        'desc': '精致迷人，打造难忘的夜晚。',
        'img': 'assets/role5.png',
      },
      {
        'desc': '约会之夜的闪耀装扮。',
        'img': 'assets/role6.png',
      },
    ],
    '健身': [
      {
        'desc': '运动与时尚的完美结合。舒适地追求目标。',
        'img': 'assets/role7.png',
      },
      {
        'desc': '现代健身爱好者的运动时尚。',
        'img': 'assets/role8.png',
      },
      {
        'desc': '时尚运动风。升级你的健身衣橱。',
        'img': 'assets/role9.png',
      },
    ],
    '居家': [
      {
        'desc': '舒适惬意的居家风格。放松也要有型。',
        'img': 'assets/role10.png',
      },
      {
        'desc': '奢华居家服。家是时尚的起点。',
        'img': 'assets/role11.png',
      },
      {
        'desc': '轻松舒适。适合居家办公或休闲放松。',
        'img': 'assets/role12.png',
      },
    ],
    '工作': [
      {
        'desc': '职场精英范。每一步都充满自信。',
        'img': 'assets/role13.png',
      },
      {
        'desc': '专业干练，又不失个性。',
        'img': 'assets/role14.png',
      },
      {
        'desc': '重新定义职场穿搭。成功从外表开始。',
        'img': 'assets/role15.png',
      },
    ],
    '派对': [
      {
        'desc': '派对-ready！比迪斯科球还闪耀。',
        'img': 'assets/role1.png',
      },
      {
        'desc': '夜间派对的华丽装扮。每次出场都令人难忘。',
        'img': 'assets/role3.png',
      },
      {
        'desc': '音乐节狂野或夜店时尚。由你决定风格。',
        'img': 'assets/role5.png',
      },
    ],
  };

  void _selectScene(String scene) {
    setState(() {
      _selectedScene = scene;
      for (var s in _scenes) {
        s['active'] = s['label'] == scene;
      }
    });
  }

  Future<void> _saveOutfit(int index) async {
    await AppState.instance.toggleOutfitSaved(index);

    if (AppState.instance.outfits[index].isSaved) {
      _showSnackBar('穿搭已保存到衣橱！💾');
    } else {
      _showSnackBar('已从收藏中移除');
    }
  }

  void _likeOutfit(int index) {
    _showSnackBar('已添加到喜欢！❤️');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showOutfitDetail(OutfitCard outfit, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _OutfitDetailSheet(
        outfit: outfit,
        index: index,
        onSave: () => _saveOutfit(index),
        onLike: () => _likeOutfit(index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final spacing = ResponsiveHelper.responsiveSpacing(context);
        final smallSpacing = ResponsiveHelper.responsiveSpacing(context, base: 16);

        return ListenableBuilder(
          listenable: AppState.instance,
          builder: (context, _) {
            return Scaffold(
              backgroundColor: AppColors.backgroundLight,
              body: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: spacing * 0.8),
                          _buildSceneSelector(),
                          SizedBox(height: spacing * 0.8),
                          _buildAIActionButton(),
                          SizedBox(height: spacing),
                          _buildStyleTestButton(),
                          SizedBox(height: spacing * 1.3),
                          _buildRecommendationsHeader(),
                          SizedBox(height: spacing * 0.65),
                          _buildOutfitCarousel(),
                          SizedBox(height: spacing * 1.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStyleTestButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = ResponsiveHelper.getScaleFactor(context);
        final padding = ResponsiveHelper.responsivePadding(context);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StyleTestPage()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18 * scale),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.gradientRoseStart,
                    AppColors.gradientRoseEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientRoseStart.withOpacity(0.35),
                    blurRadius: 16 * scale,
                    offset: Offset(0, 6 * scale),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.psychology_rounded,
                    color: Colors.white,
                    size: 22 * scale,
                  ),
                  SizedBox(width: 10 * scale),
                  Text(
                    '风格测试',
                    style: TextStyle(
                      fontSize: 16 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = ResponsiveHelper.getScaleFactor(context);
        final padding = ResponsiveHelper.responsivePadding(context);

        return Container(
          padding: EdgeInsets.symmetric(horizontal: padding, vertical: 16 * scale),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.backgroundLight,
                Color(0xFFF3E8FF),
                Color(0xFFE8F4FD),
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16 * scale,
                    vertical: 8 * scale,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientOrangeStart,
                        AppColors.gradientOrangeEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradientOrangeStart.withOpacity(0.3),
                        blurRadius: 10 * scale,
                        offset: Offset(0, 3 * scale),
                      ),
                    ],
                  ),
                  child: Text(
                    '小搭',
                    style: TextStyle(
                      fontSize: 22 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
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

  Widget _buildSceneSelector() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = ResponsiveHelper.getScaleFactor(context);
        final padding = ResponsiveHelper.responsivePadding(context);

        return SizedBox(
          height: 50 * scale,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: padding),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _scenes.length,
            separatorBuilder: (_, __) => SizedBox(width: 12 * scale),
            itemBuilder: (context, index) {
              final scene = _scenes[index];
              final isActive = scene['active'] as bool;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  _selectScene(scene['label'] as String);
                },
                child: _SceneChip(
                  icon: scene['icon'] as IconData,
                  label: scene['label'] as String,
                  isActive: isActive,
                  index: index,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildAIActionButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = ResponsiveHelper.getScaleFactor(context);
        final padding = ResponsiveHelper.responsivePadding(context);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiStylistChatPage()),
              );
            },
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 22 * scale),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.gradientPurpleStart,
                    AppColors.gradientPurpleEnd,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gradientPurpleStart.withOpacity(0.4),
                    blurRadius: 24 * scale,
                    offset: Offset(0, 10 * scale),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 28 * scale,
                  ),
                  SizedBox(width: 12 * scale),
                  Text(
                    '小搭帮我搭',
                    style: TextStyle(
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRecommendationsHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = ResponsiveHelper.getScaleFactor(context);
        final padding = ResponsiveHelper.responsivePadding(context);

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.all(10 * scale),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.gradientTealStart,
                      AppColors.gradientTealEnd,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gradientTealStart.withOpacity(0.3),
                      blurRadius: 12 * scale,
                      offset: Offset(0, 4 * scale),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.recommend_rounded,
                  color: Colors.white,
                  size: 20 * scale,
                ),
              ),
              SizedBox(width: 12 * scale),
              Text(
                '为你推荐',
                style: TextStyle(
                  fontSize: 20 * scale,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMain,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOutfitCarousel() {
    final sceneOutfits = _sceneOutfitTemplates[_selectedScene] ?? [];

    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = ResponsiveHelper.getScaleFactor(context);
        final padding = ResponsiveHelper.responsivePadding(context);
        final responsiveHeight = ResponsiveHelper.responsiveHeight(context, 480);

        return SizedBox(
          height: responsiveHeight,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: padding),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: sceneOutfits.length,
            separatorBuilder: (_, __) => SizedBox(width: 20 * scale),
            itemBuilder: (context, index) {
              final outfitData = sceneOutfits[index];
              return GestureDetector(
                onTap: () => _showSceneOutfitDetail(outfitData, index),
                child: _SceneOutfitCard(
                  outfitData: outfitData,
                  index: index,
                  scene: _selectedScene,
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _showSceneOutfitDetail(Map<String, String> outfitData, int index) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _SceneOutfitDetailSheet(
        outfitData: outfitData,
        index: index,
        scene: _selectedScene,
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgColor, iconColor.withOpacity(0.08)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [iconColor, iconColor.withOpacity(0.7)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: iconColor.withOpacity(0.25),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _SceneChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final int index;

  const _SceneChip({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.index,
  });

  List<Color> _getGradientColors() {
    final gradients = [
      [AppColors.gradientPinkStart, AppColors.gradientPinkEnd],
      [AppColors.gradientPurpleStart, AppColors.gradientPurpleEnd],
      [AppColors.gradientTealStart, AppColors.gradientTealEnd],
      [AppColors.gradientOrangeStart, AppColors.gradientOrangeEnd],
      [AppColors.gradientRoseStart, AppColors.gradientRoseEnd],
      [AppColors.gradientPinkStart, AppColors.gradientPurpleEnd],
    ];
    return gradients[index % gradients.length];
  }

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.getScaleFactor(context);
    final colors = _getGradientColors();
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: EdgeInsets.symmetric(horizontal: 18 * scale, vertical: 10 * scale),
      decoration: BoxDecoration(
        gradient: isActive ? LinearGradient(colors: colors) : null,
        color: isActive ? null : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive ? colors[0] : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: colors[0].withOpacity(0.3),
                  blurRadius: 12 * scale,
                  offset: Offset(0, 4 * scale),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6 * scale,
                  offset: Offset(0, 2 * scale),
                ),
              ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18 * scale,
            color: isActive ? Colors.white : Colors.grey.shade600,
          ),
          SizedBox(width: 8 * scale),
          Text(
            label,
            style: TextStyle(
              fontSize: 14 * scale,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? Colors.white : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

class _OutfitCard extends StatefulWidget {
  final OutfitCard outfit;
  final int index;
  final VoidCallback onSave;
  final VoidCallback onLike;

  const _OutfitCard({
    required this.outfit,
    required this.index,
    required this.onSave,
    required this.onLike,
  });

  @override
  State<_OutfitCard> createState() => _OutfitCardState();
}

class _OutfitCardState extends State<_OutfitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _likeController;
  late Animation<double> _scaleAnimation;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _likeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 50,
      ),
    ]).animate(_likeController);
  }

  @override
  void dispose() {
    _likeController.dispose();
    super.dispose();
  }

  void _handleLike() {
    HapticFeedback.lightImpact();
    setState(() {
      _isLiked = !_isLiked;
    });
    _likeController.forward().then((_) => _likeController.reverse());
    widget.onLike();
  }

  Widget _buildOutfitImage(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientPinkStart,
                AppColors.gradientPinkEnd,
              ],
            ),
          ),
          child: const Icon(
            Icons.image_outlined,
            size: 48,
            color: Colors.white,
          ),
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientPinkStart,
              AppColors.gradientPinkEnd,
            ],
          ),
        ),
        child: const Icon(
          Icons.image_outlined,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.getScaleFactor(context);
    final outfit = widget.outfit;
    final onSave = widget.onSave;

    return SizedBox(
      width: ResponsiveHelper.responsiveWidth(context, 310),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 24 * scale,
              offset: Offset(0, 10 * scale),
            ),
          ],
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    child: _buildOutfitImage(outfit.imageUrl),
                  ),

                  Positioned(
                    top: 16 * scale,
                    left: 16 * scale,
                    right: 16 * scale,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (outfit.scene != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10 * scale,
                              vertical: 6 * scale,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.gradientTealStart,
                                  AppColors.gradientTealEnd,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gradientTealStart
                                      .withOpacity(0.3),
                                  blurRadius: 8 * scale,
                                  offset: Offset(0, 2 * scale),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 12 * scale,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4 * scale),
                                Text(
                                  outfit.scene!,
                                  style: TextStyle(
                                    fontSize: 11 * scale,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox(),

                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10 * scale,
                            vertical: 6 * scale,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 12 * scale,
                              ),
                              SizedBox(width: 4 * scale),
                              Text(
                                outfit.matchPercentage,
                                style: TextStyle(
                                  fontSize: 11 * scale,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(20 * scale),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10 * scale),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppColors.gradientPurpleStart,
                              AppColors.gradientPurpleEnd,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gradientPurpleStart.withOpacity(
                                0.25,
                              ),
                              blurRadius: 10 * scale,
                              offset: Offset(0, 3 * scale),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.psychology_rounded,
                          color: Colors.white,
                          size: 20 * scale,
                        ),
                      ),
                      SizedBox(width: 12 * scale),
                      Expanded(
                        child: Text(
                          outfit.description,
                          style: TextStyle(
                            fontSize: 14 * scale,
                            color: Colors.grey.shade700,
                            height: 1.5,
                            fontStyle: FontStyle.italic,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20 * scale),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: onSave,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(vertical: 14 * scale),
                            decoration: BoxDecoration(
                              gradient: outfit.isSaved
                                  ? const LinearGradient(
                                      colors: [
                                        AppColors.gradientTealStart,
                                        AppColors.gradientTealEnd,
                                      ],
                                    )
                                  : const LinearGradient(
                                      colors: [
                                        AppColors.gradientPurpleStart,
                                        AppColors.gradientPurpleEnd,
                                      ],
                                    ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (outfit.isSaved
                                              ? AppColors.gradientTealStart
                                              : AppColors.gradientPurpleStart)
                                          .withOpacity(0.3),
                                  blurRadius: 12 * scale,
                                  offset: Offset(0, 4 * scale),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  outfit.isSaved
                                      ? Icons.bookmark_added_rounded
                                      : Icons.bookmark_border_rounded,
                                  color: Colors.white,
                                  size: 18 * scale,
                                ),
                                SizedBox(width: 6 * scale),
                                Text(
                                  outfit.isSaved ? '已保存到衣橱' : '保存穿搭',
                                  style: TextStyle(
                                    fontSize: 14 * scale,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12 * scale),
                      GestureDetector(
                        onTap: _handleLike,
                        behavior: HitTestBehavior.opaque,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: Container(
                            width: 48 * scale,
                            height: 48 * scale,
                            decoration: BoxDecoration(
                              gradient: _isLiked
                                  ? const LinearGradient(
                                      colors: [
                                        AppColors.gradientRoseStart,
                                        AppColors.gradientRoseEnd,
                                      ],
                                    )
                                  : null,
                              color: _isLiked ? null : Colors.grey.shade50,
                              border: Border.all(
                                color: _isLiked
                                    ? AppColors.gradientRoseStart
                                    : Colors.grey.shade200,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: _isLiked
                                  ? [
                                      BoxShadow(
                                        color: AppColors.gradientRoseStart
                                            .withOpacity(0.3),
                                        blurRadius: 10 * scale,
                                        offset: Offset(0, 3 * scale),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              _isLiked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: _isLiked
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              size: 22 * scale,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutfitDetailSheet extends StatelessWidget {
  final OutfitCard outfit;
  final int index;
  final VoidCallback onSave;
  final VoidCallback onLike;

  const _OutfitDetailSheet({
    required this.outfit,
    required this.index,
    required this.onSave,
    required this.onLike,
  });

  Widget _buildDetailImage(BuildContext context, String url) {
    final height = MediaQuery.of(context).size.height * 0.45;
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: double.infinity,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientPinkStart,
                AppColors.gradientPinkEnd,
              ],
            ),
          ),
          child: const Icon(
            Icons.image_outlined,
            size: 48,
            color: Colors.white,
          ),
        ),
      );
    }
    return Image.network(
      url,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: double.infinity,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientPinkStart,
              AppColors.gradientPinkEnd,
            ],
          ),
        ),
        child: const Icon(
          Icons.image_outlined,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.getScaleFactor(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16 * scale),
            child: Container(
              width: 48 * scale,
              height: 5 * scale,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: _buildDetailImage(context, outfit.imageUrl),
          ),

          Padding(
            padding: EdgeInsets.all(24 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14 * scale,
                            vertical: 8 * scale,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                AppColors.gradientTealStart,
                                AppColors.gradientTealEnd,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.gradientTealStart.withOpacity(
                                  0.3,
                                ),
                                blurRadius: 8 * scale,
                                offset: Offset(0, 2 * scale),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.analytics_rounded,
                                size: 16 * scale,
                                color: Colors.white,
                              ),
                              SizedBox(width: 6 * scale),
                              Text(
                                outfit.matchPercentage,
                                style: TextStyle(
                                  fontSize: 14 * scale,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (outfit.scene != null) ...[
                          SizedBox(width: 12 * scale),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14 * scale,
                              vertical: 8 * scale,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.gradientPurpleStart,
                                  AppColors.gradientPurpleEnd,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gradientPurpleStart
                                      .withOpacity(0.25),
                                  blurRadius: 8 * scale,
                                  offset: Offset(0, 2 * scale),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 14 * scale,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 6 * scale),
                                Text(
                                  outfit.scene!,
                                  style: TextStyle(
                                    fontSize: 13 * scale,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),

                    Row(
                      children: [
                        GestureDetector(
                          onTap: onSave,
                          child: Container(
                            padding: EdgeInsets.all(10 * scale),
                            decoration: BoxDecoration(
                              gradient: outfit.isSaved
                                  ? const LinearGradient(
                                      colors: [
                                        AppColors.gradientTealStart,
                                        AppColors.gradientTealEnd,
                                      ],
                                    )
                                  : null,
                              color: outfit.isSaved ? null : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: outfit.isSaved
                                    ? AppColors.gradientTealStart
                                    : Colors.grey.shade300,
                              ),
                              boxShadow: outfit.isSaved
                                  ? [
                                      BoxShadow(
                                        color: AppColors.gradientTealStart
                                            .withOpacity(0.25),
                                        blurRadius: 8 * scale,
                                        offset: Offset(0, 2 * scale),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              outfit.isSaved
                                  ? Icons.bookmark_added_rounded
                                  : Icons.bookmark_border_rounded,
                              color: outfit.isSaved
                                  ? Colors.white
                                  : Colors.grey.shade500,
                              size: 22 * scale,
                            ),
                          ),
                        ),
                        SizedBox(width: 12 * scale),
                        GestureDetector(
                          onTap: onLike,
                          child: Container(
                            padding: EdgeInsets.all(10 * scale),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.gradientRoseStart,
                                  AppColors.gradientRoseEnd,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gradientRoseStart
                                      .withOpacity(0.25),
                                  blurRadius: 8 * scale,
                                  offset: Offset(0, 2 * scale),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.favorite_rounded,
                              color: Colors.white,
                              size: 22 * scale,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24 * scale),

                Container(
                  padding: EdgeInsets.all(16 * scale),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientPurpleStart,
                        AppColors.gradientPurpleEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradientPurpleStart.withOpacity(0.2),
                        blurRadius: 12 * scale,
                        offset: Offset(0, 4 * scale),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 24 * scale,
                      ),
                      SizedBox(width: 12 * scale),
                      Expanded(
                        child: Text(
                          outfit.description,
                          style: TextStyle(
                            fontSize: 16 * scale,
                            color: Colors.white,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 32 * scale),

                GestureDetector(
                  onTap: () {
                    onSave();
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 18 * scale),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppColors.gradientTealStart,
                          AppColors.gradientTealEnd,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gradientTealStart.withOpacity(0.35),
                          blurRadius: 16 * scale,
                          offset: Offset(0, 6 * scale),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          outfit.isSaved
                              ? Icons.check_circle_rounded
                              : Icons.save_alt_rounded,
                          color: Colors.white,
                          size: 22 * scale,
                        ),
                        SizedBox(width: 10 * scale),
                        Text(
                          '保存到衣橱',
                          style: TextStyle(
                            fontSize: 18 * scale,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24 * scale),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SceneOutfitCard extends StatelessWidget {
  final Map<String, String> outfitData;
  final int index;
  final String scene;

  const _SceneOutfitCard({
    required this.outfitData,
    required this.index,
    required this.scene,
  });

  Widget _buildOutfitImage(String url) {
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientPinkStart,
                AppColors.gradientPinkEnd,
              ],
            ),
          ),
          child: const Icon(
            Icons.image_outlined,
            size: 48,
            color: Colors.white,
          ),
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientPinkStart,
              AppColors.gradientPinkEnd,
            ],
          ),
        ),
        child: const Icon(
          Icons.image_outlined,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.getScaleFactor(context);

    return SizedBox(
      width: ResponsiveHelper.responsiveWidth(context, 310),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 24 * scale,
              offset: Offset(0, 10 * scale),
            ),
          ],
          border: Border.all(color: AppColors.cardBorder, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    child: _buildOutfitImage(outfitData['img']!),
                  ),
                  Positioned(
                    top: 16 * scale,
                    left: 16 * scale,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10 * scale,
                        vertical: 6 * scale,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.gradientTealStart,
                            AppColors.gradientTealEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gradientTealStart.withOpacity(0.3),
                            blurRadius: 8 * scale,
                            offset: Offset(0, 2 * scale),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 12 * scale,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4 * scale),
                          Text(
                            scene,
                            style: TextStyle(
                              fontSize: 11 * scale,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20 * scale),
              child: Text(
                outfitData['desc']!,
                style: TextStyle(
                  fontSize: 14 * scale,
                  color: Colors.grey.shade700,
                  height: 1.5,
                  fontStyle: FontStyle.italic,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SceneOutfitDetailSheet extends StatelessWidget {
  final Map<String, String> outfitData;
  final int index;
  final String scene;

  const _SceneOutfitDetailSheet({
    required this.outfitData,
    required this.index,
    required this.scene,
  });

  Widget _buildDetailImage(BuildContext context, String url) {
    final height = MediaQuery.of(context).size.height * 0.45;
    if (url.startsWith('assets/')) {
      return Image.asset(
        url,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: double.infinity,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.gradientPinkStart,
                AppColors.gradientPinkEnd,
              ],
            ),
          ),
          child: const Icon(
            Icons.image_outlined,
            size: 48,
            color: Colors.white,
          ),
        ),
      );
    }
    return Image.network(
      url,
      width: double.infinity,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: double.infinity,
        height: height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.gradientPinkStart,
              AppColors.gradientPinkEnd,
            ],
          ),
        ),
        child: const Icon(
          Icons.image_outlined,
          size: 48,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scale = ResponsiveHelper.getScaleFactor(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(16 * scale),
            child: Container(
              width: 48 * scale,
              height: 5 * scale,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: _buildDetailImage(context, outfitData['img']!),
          ),
          Padding(
            padding: EdgeInsets.all(24 * scale),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14 * scale,
                        vertical: 8 * scale,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.gradientTealStart,
                            AppColors.gradientTealEnd,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gradientTealStart.withOpacity(0.3),
                            blurRadius: 8 * scale,
                            offset: Offset(0, 2 * scale),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 16 * scale,
                            color: Colors.white,
                          ),
                          SizedBox(width: 6 * scale),
                          Text(
                            scene,
                            style: TextStyle(
                              fontSize: 14 * scale,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24 * scale),
                Container(
                  padding: EdgeInsets.all(16 * scale),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.gradientPurpleStart,
                        AppColors.gradientPurpleEnd,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.gradientPurpleStart.withOpacity(0.2),
                        blurRadius: 12 * scale,
                        offset: Offset(0, 4 * scale),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 24 * scale,
                      ),
                      SizedBox(width: 12 * scale),
                      Expanded(
                        child: Text(
                          outfitData['desc']!,
                          style: TextStyle(
                            fontSize: 16 * scale,
                            color: Colors.white,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 32 * scale),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
