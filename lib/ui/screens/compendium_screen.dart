import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/constants.dart';
import '../widgets/background_scaffold.dart';
import '../../models/role.dart';
import 'role_detail_screen.dart';

class CompendiumScreen extends StatefulWidget {
  const CompendiumScreen({super.key});

  @override
  State<CompendiumScreen> createState() => _CompendiumScreenState();
}

class _CompendiumScreenState extends State<CompendiumScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return BackgroundScaffold(
      backgroundImage: AppAssets.bgGiantLotusPond,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: const Color(
                0xFFF3E5D8,
              ).withOpacity(0.95), // 米色背景，配合整体色调
              title: Text(
                '山海图鉴',
                style: GoogleFonts.maShanZheng(
                  color: AppColors.inkBlack,
                  fontSize: isSmallScreen ? 22 : (isTablet ? 32 : 26),
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
              floating: true,
              pinned: true,
              elevation: 0,
              iconTheme: const IconThemeData(color: AppColors.inkBlack),
              bottom: TabBar(
                controller: _tabController,
                labelColor: AppColors.inkRed,
                unselectedLabelColor: AppColors.inkBlack.withOpacity(0.6),
                indicatorColor: AppColors.inkRed,
                indicatorWeight: 3,
                labelStyle: GoogleFonts.maShanZheng(
                  fontSize: isSmallScreen ? 16 : (isTablet ? 24 : 20),
                ),
                unselectedLabelStyle: GoogleFonts.maShanZheng(
                  fontSize: isSmallScreen ? 14 : (isTablet ? 20 : 18),
                ),
                tabs: const [
                  Tab(text: '角色'),
                  Tab(text: '异兽'),
                  Tab(text: '奇物'),
                  Tab(text: '灵言'),
                ],
              ),
            ),
          ];
        },
        body: Container(
          color: const Color(0xFFEBE2D5).withOpacity(0.5), // 背景稍微加深一点，衬托白色卡片
          child: TabBarView(
            controller: _tabController,
            children: [
              _RoleTab(isTablet: isTablet),
              _BeastTab(isTablet: isTablet),
              _RelicTab(isTablet: isTablet),
              _WordTab(isTablet: isTablet),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleTab extends StatelessWidget {
  final bool isTablet;

  const _RoleTab({this.isTablet = false});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;
    // 关键调整：减小 maxCrossAxisExtent 以强制显示更多列
    // 在普通手机上（宽度~390-430），设置为 100 左右可以容纳 4 列 (4*90 + spacing)
    final double cardWidth = isSmallScreen ? 85 : (isTablet ? 160 : 98);
    // 调整长宽比，使其更像竖长的卡牌，底部留白给名字
    const double childAspectRatio = 0.65;

    return GridView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 8 : (isTablet ? 24 : 10)),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: cardWidth,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: isSmallScreen ? 6 : (isTablet ? 16 : 8),
        mainAxisSpacing: isSmallScreen ? 6 : (isTablet ? 16 : 8),
      ),
      itemCount: allRoles.length,
      itemBuilder: (context, index) {
        final role = allRoles[index];
        return _RoleCard(
          role: role,
          isSmallScreen: isSmallScreen,
          isTablet: isTablet,
        );
      },
    );
  }
}

class _RoleCard extends StatelessWidget {
  final Role role;
  final bool isSmallScreen;
  final bool isTablet;

  const _RoleCard({
    required this.role,
    this.isSmallScreen = false,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    // 底部白色区域的高度
    final double footerHeight = isSmallScreen ? 32 : 38;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => RoleDetailScreen(role: role)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // 卡片整体背景设为白色
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              // 1. 上半部分：图片背景 + 图片
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: footerHeight, // 留出底部白色区域
                child: Container(
                  decoration: BoxDecoration(
                    // 修改点：使用角色元素颜色作为背景基调，更接近图1效果
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        role.elementColor.withOpacity(0.15),
                        role.elementColor.withOpacity(0.3),
                      ],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(6),
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // 背景装饰圆圈（模拟图1中的背景纹理）
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ),
                      // 图片
                      Hero(
                        tag: 'role_image_${role.id}',
                        child: Image.asset(
                          role.assetPath,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      // 底部渐变，防止图片底部太生硬
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 20,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                role.elementColor.withOpacity(0.1),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2. 底部白色区域：名字 + 星星
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: footerHeight,
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        role.name,
                        style: GoogleFonts.maShanZheng(
                          fontSize: isSmallScreen ? 13 : 15,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF2D2D2D), // 深墨色
                          height: 1.0,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          role.stars,
                          (index) => Icon(
                            Icons.star,
                            color: const Color(0xFFFFC107), // 明亮的金色
                            size: isSmallScreen ? 10 : 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 3. 左上角：元素图标
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: role.elementColor.withOpacity(0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    _getElementIcon(role.element),
                    size: isSmallScreen ? 10 : 12,
                    color: role.elementColor,
                  ),
                ),
              ),

              // 4. 左上角：“核”字印章 (修改为圆形印章样式)
              Positioned(
                top: isSmallScreen ? 20 : 24,
                left: 2,
                child: Transform.rotate(
                  angle: -0.2, // 稍微倾斜，更像盖章
                  child: Container(
                    width: isSmallScreen ? 16 : 18,
                    height: isSmallScreen ? 16 : 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F), // 鲜艳的印泥红
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.8),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 1,
                        ),
                      ],
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '核',
                          style: GoogleFonts.maShanZheng(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // 5. 右上角：稀有度 (艺术字风格增强)
              Positioned(
                top: 2,
                right: 4,
                child: Text(
                  role.rarityLabel,
                  style: GoogleFonts.notoSerif(
                    color: role.rarityLabel == 'UR'
                        ? const Color(0xFFD32F2F) // UR 用鲜红
                        : const Color(0xFFE64A19), // SSR 用橘红
                    fontWeight: FontWeight.w900,
                    fontSize: isSmallScreen ? 12 : 14,
                    fontStyle: FontStyle.italic,
                    shadows: [
                      const Shadow(
                        color: Colors.white,
                        offset: Offset(-1, -1),
                        blurRadius: 0,
                      ),
                      const Shadow(
                        color: Colors.white,
                        offset: Offset(1, -1),
                        blurRadius: 0,
                      ),
                      const Shadow(
                        color: Colors.white,
                        offset: Offset(-1, 1),
                        blurRadius: 0,
                      ),
                      const Shadow(
                        color: Colors.white,
                        offset: Offset(1, 1),
                        blurRadius: 0,
                      ),
                      Shadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: const Offset(1, 2),
                        blurRadius: 2,
                      ),
                    ],
                  ),
                ),
              ),

              // 6. 右下角：搜索图标 (颜色调整为深色底)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  width: isSmallScreen ? 16 : 18,
                  height: isSmallScreen ? 16 : 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF37474F), // 深蓝灰色，类似图1
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.search,
                    size: isSmallScreen ? 9 : 11,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getElementIcon(RoleElement element) {
    switch (element) {
      case RoleElement.metal:
        return Icons.gavel;
      case RoleElement.wood:
        return Icons.forest;
      case RoleElement.water:
        return Icons.water_drop;
      case RoleElement.fire:
        return Icons.local_fire_department;
      case RoleElement.earth:
        return Icons.landscape;
      case RoleElement.wind:
        return Icons.air;
      case RoleElement.thunder:
        return Icons.flash_on;
      case RoleElement.yin:
        return Icons.dark_mode;
      case RoleElement.yang:
        return Icons.light_mode;
    }
  }
}

// 保持原来的 BeastTab, RelicTab, WordTab 不变，或者按需微调
// 为了代码完整性，这里包含它们，但主要改动在上面

class _BeastTab extends StatelessWidget {
  final bool isTablet;

  _BeastTab({this.isTablet = false});

  final List<Map<String, dynamic>> beasts = [
    {
      'name': '混沌',
      'title': '太古四凶',
      'desc': '其状如犬，长毛，四足，似罴而无爪，有目而不见，行不开，有两耳而不闻。',
      'detail':
          '混沌是天地未开之时的朦胧状态，象征着无序与混乱。在山海经中，它被描述为一种没有面目、浑浑噩噩的生物。它厌恶高尚的人，却会听从恶人的指挥。',
      'danger': 5,
      'icon': Icons.cloud,
    },
    {
      'name': '饕餮',
      'title': '贪食之欲',
      'desc': '其状如羊身人面，其目在腋下，虎齿人爪，其音如婴儿。',
      'detail': '饕餮是贪欲的化身，传说它极其贪吃，甚至吃掉了自己的身体，只剩下一个大头和一张大嘴。它是极度危险的存在，能够吞噬一切物质。',
      'danger': 4,
      'icon': Icons.face_retouching_off,
    },
    {
      'name': '穷奇',
      'title': '惩善扬恶',
      'desc': '状如虎，有翼，食人从首始，所食被发，在犬北。',
      'detail':
          '穷奇是一种会飞的老虎，它性格怪异，看到有人打架，它会去吃掉有理的一方；听说有人忠信，它就去咬掉他的鼻子。它是背信弃义的象征。',
      'danger': 4,
      'icon': Icons.catching_pokemon,
    },
    {
      'name': '梼杌',
      'title': '顽固之灵',
      'desc': '人面虎足，猪口牙，尾长一丈八尺，在西方，名曰梼杌。',
      'detail': '梼杌原本是北方天帝颛顼的儿子，因桀骜不驯而死后化为怪兽。它代表着顽固不化和难以教导的愚蠢，拥有强大的物理破坏力。',
      'danger': 3,
      'icon': Icons.pets,
    },
    {
      'name': '九尾狐',
      'title': '青丘之主',
      'desc': '青丘之山，有兽焉，其状如狐而九尾，其音如婴儿，能食人。',
      'detail': '九尾狐不仅是祥瑞之兽，也常被视为魅惑的象征。食其肉者不逢妖邪之气。在墨世之中，九尾狐多以幻术迷惑人心。',
      'danger': 3,
      'icon': Icons.category,
    },
    {
      'name': '刑天',
      'title': '断首战神',
      'desc': '刑天与帝至此争神，帝断其首，葬之常羊之山，乃以乳为目，以脐为口，操干戚以舞。',
      'detail': '刑天象征着不屈的战斗意志。即使失去了头颅，依然挥舞着盾牌和巨斧战斗。这种精神力量使它成为极其难缠的对手。',
      'danger': 5,
      'icon': Icons.accessibility_new,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : (isTablet ? 24 : 16)),
      itemCount: beasts.length,
      itemBuilder: (context, index) {
        final beast = beasts[index];
        return _CompendiumCard(
          title: beast['name'],
          subtitle: beast['title'],
          description: beast['desc'],
          icon: beast['icon'],
          color: AppColors.inkRed,
          onTap: () => _showDetail(context, beast, type: 'beast'),
          isSmallScreen: isSmallScreen,
          isTablet: isTablet,
        );
      },
    );
  }

  void _showDetail(
    BuildContext context,
    Map<String, dynamic> data, {
    required String type,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DetailModal(data: data, type: type),
    );
  }
}

class _RelicTab extends StatelessWidget {
  final bool isTablet;

  _RelicTab({this.isTablet = false});

  final List<Map<String, dynamic>> relics = [
    {
      'name': '首 (Head)',
      'title': '智慧之源',
      'desc': '头颅是精神的居所，决定了视野与洞察力。',
      'detail': '在肢体拼装中，头部部件通常提供【视界】属性，决定了探索迷雾的能力。高级的头部部件还能提供额外的策略选项。',
      'rarity': '关键',
      'icon': Icons.psychology,
    },
    {
      'name': '躯 (Body)',
      'title': '生命之基',
      'desc': '躯干是承载力量的容器，决定了生存的韧性。',
      'detail': '躯干部件主要提供【生命值】与【防御力】。坚固的躯干是承受异兽猛烈攻击的基础，也是维持理智不崩坏的保障。',
      'rarity': '核心',
      'icon': Icons.accessibility,
    },
    {
      'name': '足 (Legs)',
      'title': '行进之力',
      'desc': '双足丈量大地，决定了行动的速度与闪避。',
      'detail': '腿部部件提供【速度】属性。高速度不仅意味着先手攻击的机会，还能在地图探索中规避危险事件。',
      'rarity': '基础',
      'icon': Icons.directions_walk,
    },
    {
      'name': '尾 (Tail)',
      'title': '平衡之末',
      'desc': '尾部维持平衡，亦可作为出其不意的武器。',
      'detail': '尾部是特殊的辅助部件，往往带有特殊的技能或被动效果。灵活运用尾部部件可以改变战斗的节奏。',
      'rarity': '特殊',
      'icon': Icons.all_inclusive,
    },
    {
      'name': '灵茶',
      'title': '清心之饮',
      'desc': '采自云深之处的茶叶，饮之可安神。',
      'detail': '在墨世中，理智（Sanity）如同生命一般重要。灵茶是恢复理智的基础物资，建议常备。',
      'rarity': '消耗品',
      'icon': Icons.local_cafe,
    },
    {
      'name': '凝神丹',
      'title': '定魂神药',
      'desc': '炼丹师的杰作，能强行压制心魔。',
      'detail': '当理智濒临崩溃时，凝神丹是唯一的救命稻草。它的效果远超灵茶，但价格也更为昂贵。',
      'rarity': '珍稀消耗品',
      'icon': Icons.spa,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    return GridView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : (isTablet ? 24 : 16)),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isTablet ? 3 : 2,
        childAspectRatio: isSmallScreen ? 0.75 : (isTablet ? 0.85 : 0.85),
        crossAxisSpacing: isSmallScreen ? 12 : (isTablet ? 20 : 16),
        mainAxisSpacing: isSmallScreen ? 12 : (isTablet ? 20 : 16),
      ),
      itemCount: relics.length,
      itemBuilder: (context, index) {
        final relic = relics[index];
        return _CompendiumGridCard(
          title: relic['name'],
          subtitle: relic['title'],
          icon: relic['icon'],
          color: AppColors.woodDark,
          onTap: () => _showDetail(context, relic, type: 'relic'),
          isSmallScreen: isSmallScreen,
          isTablet: isTablet,
        );
      },
    );
  }

  void _showDetail(
    BuildContext context,
    Map<String, dynamic> data, {
    required String type,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DetailModal(data: data, type: type),
    );
  }
}

class _WordTab extends StatelessWidget {
  final bool isTablet;

  _WordTab({this.isTablet = false});

  final List<Map<String, dynamic>> words = [
    {
      'name': '金 (Metal)',
      'title': '肃杀之气',
      'desc': '西方之行，主杀伐，锐不可当。',
      'detail': '金系灵言专注于直接伤害与穿透。它们通常具有高攻击力，能够无视部分防御，是斩杀敌人的利器。',
      'effect': '高额伤害 / 穿透',
      'icon': Icons.gavel,
      'color': Colors.amber,
    },
    {
      'name': '木 (Wood)',
      'title': '生生不息',
      'desc': '东方之行，主生长，恢复生机。',
      'detail': '木系灵言擅长恢复与持续效果。它们可以治疗伤势，或者施加中毒效果，慢慢折磨敌人。',
      'effect': '治疗 / 中毒',
      'icon': Icons.forest,
      'color': Colors.green,
    },
    {
      'name': '水 (Water)',
      'title': '上善若水',
      'desc': '北方之行，主流动，变化无穷。',
      'detail': '水系灵言灵活多变，通常带有抽牌、回费等战术效果。它们能让你的卡组运转更加流畅。',
      'effect': '抽牌 / 回费',
      'icon': Icons.water_drop,
      'color': Colors.blue,
    },
    {
      'name': '火 (Fire)',
      'title': '烈焰焚天',
      'desc': '南方之行，主毁灭，爆发力强。',
      'detail': '火系灵言拥有最强的爆发力。它们往往能造成群体伤害或叠加易伤效果，在短时间内倾泻大量伤害。',
      'effect': '爆发 / 易伤',
      'icon': Icons.local_fire_department,
      'color': Colors.red,
    },
    {
      'name': '土 (Earth)',
      'title': '厚德载物',
      'desc': '中央之行，主承载，坚不可摧。',
      'detail': '土系灵言侧重于防御与稳固。它们提供护盾与减伤效果，是你在强敌面前生存的关键。',
      'effect': '护盾 / 减伤',
      'icon': Icons.landscape,
      'color': Colors.brown,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    return ListView.builder(
      padding: EdgeInsets.all(isSmallScreen ? 12 : (isTablet ? 24 : 16)),
      itemCount: words.length,
      itemBuilder: (context, index) {
        final word = words[index];
        return _CompendiumCard(
          title: word['name'],
          subtitle: word['title'],
          description: word['desc'],
          icon: word['icon'],
          color: word['color'],
          onTap: () => _showDetail(context, word, type: 'word'),
          isSmallScreen: isSmallScreen,
          isTablet: isTablet,
        );
      },
    );
  }

  void _showDetail(
    BuildContext context,
    Map<String, dynamic> data, {
    required String type,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _DetailModal(data: data, type: type),
    );
  }
}

class _CompendiumCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isSmallScreen;
  final bool isTablet;

  const _CompendiumCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isSmallScreen = false,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        bottom: isSmallScreen ? 12 : (isTablet ? 20 : 16),
      ),
      color: AppColors.bgPaper,
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 12 : (isTablet ? 24 : 16)),
          child: Row(
            children: [
              Container(
                width: isSmallScreen ? 48 : (isTablet ? 72 : 60),
                height: isSmallScreen ? 48 : (isTablet ? 72 : 60),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isSmallScreen ? 24 : (isTablet ? 36 : 30),
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : (isTablet ? 24 : 16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.maShanZheng(
                            fontSize: isSmallScreen ? 18 : (isTablet ? 26 : 22),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 12 : 8,
                            vertical: isTablet ? 4 : 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            subtitle,
                            style: GoogleFonts.notoSerifSc(
                              fontSize: isSmallScreen
                                  ? 10
                                  : (isTablet ? 14 : 12),
                              color: color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 4 : (isTablet ? 12 : 8)),
                    Text(
                      description,
                      style: GoogleFonts.notoSerifSc(
                        fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14),
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey,
                size: isSmallScreen ? 20 : (isTablet ? 32 : 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompendiumGridCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isSmallScreen;
  final bool isTablet;

  const _CompendiumGridCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isSmallScreen = false,
    this.isTablet = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.bgPaper,
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 8 : (isTablet ? 16 : 12)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: isSmallScreen ? 40 : (isTablet ? 64 : 50),
                height: isSmallScreen ? 40 : (isTablet ? 64 : 50),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: color.withOpacity(0.5)),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: isSmallScreen ? 22 : (isTablet ? 36 : 28),
                ),
              ),
              SizedBox(height: isSmallScreen ? 8 : (isTablet ? 16 : 12)),
              Text(
                title,
                style: GoogleFonts.maShanZheng(
                  fontSize: isSmallScreen ? 16 : (isTablet ? 22 : 18),
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 2 : (isTablet ? 8 : 4)),
              Text(
                subtitle,
                style: GoogleFonts.notoSerifSc(
                  fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 12),
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailModal extends StatelessWidget {
  final Map<String, dynamic> data;
  final String type;

  const _DetailModal({required this.data, required this.type});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      height:
          MediaQuery.of(context).size.height *
          (isSmallScreen ? 0.75 : (isTablet ? 0.6 : 0.7)),
      decoration: const BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Center(
            child: Container(
              width: isTablet ? 60 : 40,
              height: isTablet ? 6 : 4,
              margin: EdgeInsets.symmetric(vertical: isTablet ? 16 : 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(
                isSmallScreen ? 16 : (isTablet ? 32 : 24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(
                          isSmallScreen ? 12 : (isTablet ? 24 : 16),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.woodLight.withOpacity(0.3),
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.woodDark),
                        ),
                        child: Icon(
                          data['icon'] as IconData,
                          size: isSmallScreen ? 32 : (isTablet ? 56 : 40),
                          color: AppColors.inkBlack,
                        ),
                      ),
                      SizedBox(
                        width: isSmallScreen ? 16 : (isTablet ? 32 : 20),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data['name'],
                              style: GoogleFonts.maShanZheng(
                                fontSize: isSmallScreen
                                    ? 26
                                    : (isTablet ? 42 : 32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              data['title'],
                              style: GoogleFonts.notoSerifSc(
                                fontSize: isSmallScreen
                                    ? 14
                                    : (isTablet ? 20 : 16),
                                color: AppColors.inkRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Divider(
                    height: isSmallScreen ? 30 : (isTablet ? 50 : 40),
                    color: AppColors.inkBlack,
                  ),

                  // Content
                  Text(
                    '【古籍记载】',
                    style: GoogleFonts.maShanZheng(
                      fontSize: isSmallScreen ? 18 : (isTablet ? 24 : 20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : (isTablet ? 12 : 8)),
                  Container(
                    padding: EdgeInsets.all(
                      isSmallScreen ? 12 : (isTablet ? 24 : 16),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.woodLight.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.woodDark.withOpacity(0.2),
                      ),
                    ),
                    child: Text(
                      data['desc'],
                      style: GoogleFonts.notoSerifSc(
                        fontSize: isSmallScreen ? 14 : (isTablet ? 20 : 16),
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  SizedBox(height: isSmallScreen ? 16 : (isTablet ? 32 : 24)),

                  Text(
                    '【墨世研析】',
                    style: GoogleFonts.maShanZheng(
                      fontSize: isSmallScreen ? 18 : (isTablet ? 24 : 20),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : (isTablet ? 12 : 8)),
                  Text(
                    data['detail'] ?? '',
                    style: GoogleFonts.notoSerifSc(
                      fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
                      height: 1.6,
                    ),
                  ),

                  if (type == 'beast' && data['danger'] != null) ...[
                    SizedBox(height: isSmallScreen ? 16 : (isTablet ? 32 : 24)),
                    Row(
                      children: [
                        Text(
                          '危险等级：',
                          style: GoogleFonts.maShanZheng(
                            fontSize: isSmallScreen ? 16 : (isTablet ? 22 : 18),
                          ),
                        ),
                        ...List.generate(
                          5,
                          (index) => Icon(
                            index < (data['danger'] as int)
                                ? Icons.star
                                : Icons.star_border,
                            color: AppColors.inkRed,
                            size: isSmallScreen ? 18 : (isTablet ? 28 : 20),
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (type == 'word' && data['effect'] != null) ...[
                    SizedBox(height: isSmallScreen ? 16 : (isTablet ? 32 : 24)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 12 : (isTablet ? 24 : 16),
                        vertical: isSmallScreen ? 6 : (isTablet ? 12 : 8),
                      ),
                      decoration: BoxDecoration(
                        color: (data['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: (data['color'] as Color).withOpacity(0.5),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flash_on,
                            size: isSmallScreen ? 16 : (isTablet ? 24 : 18),
                            color: data['color'],
                          ),
                          SizedBox(width: isTablet ? 16 : 8),
                          Text(
                            '特性：${data['effect']}',
                            style: GoogleFonts.notoSerifSc(
                              fontSize: isSmallScreen
                                  ? 14
                                  : (isTablet ? 20 : 16),
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
