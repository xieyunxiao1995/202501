import 'package:flutter/material.dart';
import '../core/app_colors.dart';

enum Rarity { ssrPlus, ssr, sr, r }

enum ElementType { water, earth, fire, wind }

class Character {
  final String name;
  final String image;
  final Rarity rarity;
  final ElementType element;
  final int stars;
  final String description;
  final Map<String, int> stats;
  final List<String> skills;

  Character({
    required this.name,
    required this.image,
    required this.rarity,
    required this.element,
    required this.stars,
    required this.description,
    required this.stats,
    required this.skills,
  });
}

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Character> characters = [
      Character(
        name: '蛟龙',
        image: 'assets/role/Role1.png',
        rarity: Rarity.ssrPlus,
        element: ElementType.water,
        stars: 5,
        description: '潜于深渊，起则风雷。传说中的水系神兽，拥有操控洪荒之力的威能。',
        stats: {'生命': 2800, '攻击': 450, '防御': 320, '速度': 120},
        skills: ['狂浪滔天', '龙威震慑', '深渊潜行'],
      ),
      Character(
        name: '当康',
        image: 'assets/role/Role2.png',
        rarity: Rarity.r,
        element: ElementType.earth,
        stars: 3,
        description: '其形如猪，鸣叫自呼。它的出现预示着五谷丰登，是荒野中的瑞兽。',
        stats: {'生命': 1200, '攻击': 150, '防御': 200, '速度': 80},
        skills: ['坚实冲撞', '丰收之赐'],
      ),
      Character(
        name: '咸鱼',
        image: 'assets/role/Role3.png',
        rarity: Rarity.r,
        element: ElementType.water,
        stars: 3,
        description: '即便是一条咸鱼，也有翻身的梦想。虽然弱小，但在特定时刻有奇效。',
        stats: {'生命': 800, '攻击': 80, '防御': 50, '速度': 150},
        skills: ['翻身一击', '水溅跃'],
      ),
      Character(
        name: '飞鼠',
        image: 'assets/role/Role4.png',
        rarity: Rarity.sr,
        element: ElementType.wind,
        stars: 4,
        description: '穿梭于密林之巅，双翼展开可随风滑行，是极为敏捷的侦查者。',
        stats: {'生命': 1500, '攻击': 280, '防御': 120, '速度': 210},
        skills: ['疾风穿刺', '密林隐匿', '回旋风刃'],
      ),
      Character(
        name: '大鹄',
        image: 'assets/role/Role5.png',
        rarity: Rarity.r,
        element: ElementType.wind,
        stars: 3,
        description: '展翅千里，志在四方。巨大的羽翼能掀起足以吹飞屋舍的狂风。',
        stats: {'生命': 1100, '攻击': 190, '防御': 140, '速度': 130},
        skills: ['羽刃乱舞', '狂风席卷'],
      ),
      Character(
        name: '愤鸟',
        image: 'assets/role/Role6.png',
        rarity: Rarity.r,
        element: ElementType.fire,
        stars: 3,
        description: '浑身散发着不熄的热气，愤怒时会喷出火焰，虽然体型不大但脾气火爆。',
        stats: {'生命': 950, '攻击': 220, '防御': 100, '速度': 110},
        skills: ['烈焰吐息', '愤怒一击'],
      ),
      Character(
        name: '精卫',
        image: 'assets/role/Role7.png',
        rarity: Rarity.ssr,
        element: ElementType.wind,
        stars: 5,
        description: '衔木填海，意志永恒。其坚韧不拔的灵魂化作神鸟，永远在与命运抗争。',
        stats: {'生命': 2400, '攻击': 380, '防御': 280, '速度': 180},
        skills: ['衔石填海', '永恒意志', '神鸟守护'],
      ),
      Character(
        name: '应龙',
        image: 'assets/role/Role8.png',
        rarity: Rarity.ssrPlus,
        element: ElementType.water,
        stars: 5,
        description: '生有双翼的真龙，曾助黄帝征伐蚩尤。掌管雨水与河川的至高神灵。',
        stats: {'生命': 3200, '攻击': 480, '防御': 350, '速度': 110},
        skills: ['九天落水', '神龙摆尾', '真龙吐息'],
      ),
      Character(
        name: '白泽',
        image: 'assets/role/Role9.png',
        rarity: Rarity.ssr,
        element: ElementType.earth,
        stars: 5,
        description: '昆仑山上的神兽，通万物之情，晓鬼神之事。常在太平盛世出现，指点迷津。',
        stats: {'生命': 2200, '攻击': 300, '防御': 400, '速度': 90},
        skills: ['万物通晓', '瑞气东来', '灵光普照'],
      ),
      Character(
        name: '麒麟',
        image: 'assets/role/Role10.png',
        rarity: Rarity.ssrPlus,
        element: ElementType.fire,
        stars: 5,
        description: '仁兽之首，蹄不踏青草，不踩生灵。体内蕴含着纯净的祥瑞真火。',
        stats: {'生命': 3000, '攻击': 420, '防御': 380, '速度': 100},
        skills: ['祥瑞真火', '仁兽之界', '麟角破邪'],
      ),
      Character(
        name: '九尾狐',
        image: 'assets/role/Role11.png',
        rarity: Rarity.ssr,
        element: ElementType.fire,
        stars: 5,
        description: '青丘之山，有兽焉，其状如狐而九尾。善于幻化，声如婴儿，亦是太平的象征。',
        stats: {'生命': 1800, '攻击': 410, '防御': 150, '速度': 230},
        skills: ['魅惑幻术', '九尾狐火', '青丘步法'],
      ),
      Character(
        name: '鲲鹏',
        image: 'assets/role/Role12.png',
        rarity: Rarity.ssrPlus,
        element: ElementType.wind,
        stars: 5,
        description: '北冥有鱼，其名为鲲。化而为鸟，其名为鹏。横跨海洋与天空的庞大生灵。',
        stats: {'生命': 4000, '攻击': 350, '防御': 450, '速度': 80},
        skills: ['北冥吞噬', '垂天之翼', '阴阳变换'],
      ),
      Character(
        name: '刑天',
        image: 'assets/role/Role13.png',
        rarity: Rarity.ssrPlus,
        element: ElementType.earth,
        stars: 5,
        description: '战神之魂，永不屈服。纵使头颅被断，亦能以乳为目，以脐为口，操干戚而舞。',
        stats: {'生命': 3500, '攻击': 500, '防御': 300, '速度': 60},
        skills: ['战神咆哮', '干戚之舞', '不屈意志'],
      ),
      Character(
        name: '夸父',
        image: 'assets/role/Role14.png',
        rarity: Rarity.ssr,
        element: ElementType.fire,
        stars: 5,
        description: '追逐太阳的巨人。他的每一步都能跨越山川，死后化为桃林，泽被后世。',
        stats: {'生命': 3800, '攻击': 320, '防御': 320, '速度': 140},
        skills: ['逐日冲刺', '山崩地裂', '生机化木'],
      ),
      Character(
        name: '后羿',
        image: 'assets/role/Role15.png',
        rarity: Rarity.ssrPlus,
        element: ElementType.wind,
        stars: 5,
        description: '神弓在手，金乌陨落。曾射落九日，拯救万民于水火之中的英雄统领。',
        stats: {'生命': 2000, '攻击': 550, '防御': 180, '速度': 190},
        skills: ['射日神箭', '贯穿之矢', '金乌余烬'],
      ),
      Character(
        name: '嫦娥',
        image: 'assets/role/Role16.png',
        rarity: Rarity.ssr,
        element: ElementType.water,
        stars: 5,
        description: '奔月而去的仙子，在广寒宫中与玉兔相伴。掌握着清冷的月华之力。',
        stats: {'生命': 1600, '攻击': 340, '防御': 200, '速度': 200},
        skills: ['广寒月影', '月华洗礼', '清冷之息'],
      ),
      Character(
        name: '夫诸',
        image: 'assets/role/Role17.png',
        rarity: Rarity.sr,
        element: ElementType.water,
        stars: 4,
        description: '状如白鹿而四角，见则其县大水。温婉的外表下潜藏着引发洪水的力量。',
        stats: {'生命': 1400, '攻击': 220, '防御': 180, '速度': 160},
        skills: ['洪流引动', '灵鹿踏波', '纯净之水'],
      ),
      Character(
        name: '蜚',
        image: 'assets/role/Role18.png',
        rarity: Rarity.sr,
        element: ElementType.fire,
        stars: 4,
        description: '状如牛而白首，一目而蛇尾。出入水则竭，行草则死，是灾厄的象征。',
        stats: {'生命': 1900, '攻击': 260, '防御': 240, '速度': 70},
        skills: ['干旱领域', '疫病凝视', '毒蛇之尾'],
      ),
      Character(
        name: '重明鸟',
        image: 'assets/role/Role19.png',
        rarity: Rarity.sr,
        element: ElementType.wind,
        stars: 4,
        description: '目在眶内，各有二瞳。能搏逐猛兽，使妖物不敢近，是强大的守护之鸟。',
        stats: {'生命': 1300, '攻击': 310, '防御': 160, '速度': 240},
        skills: ['重明破邪', '双瞳威慑', '裂风之爪'],
      ),
      Character(
        name: '狍鸮',
        image: 'assets/role/Role20.png',
        rarity: Rarity.sr,
        element: ElementType.earth,
        stars: 4,
        description: '其状如羊身人面，目在腋下，虎齿人爪。极度贪食，能吞噬眼前的一切。',
        stats: {'生命': 2500, '攻击': 240, '防御': 300, '速度': 50},
        skills: ['无尽贪婪', '虚空吞噬', '重压践踏'],
      ),
      Character(
        name: '山神',
        image: 'assets/role/Role21.png',
        rarity: Rarity.ssr,
        element: ElementType.earth,
        stars: 5,
        description: '执掌一方山川的神灵。他的身躯便是岩石，呼吸便是山风，意志即是山之重压。',
        stats: {'生命': 3400, '攻击': 280, '防御': 480, '速度': 40},
        skills: ['群山壁垒', '地脉震颤', '岩崩天降'],
      ),
      Character(
        name: '河伯',
        image: 'assets/role/Role22.png',
        rarity: Rarity.ssr,
        element: ElementType.water,
        stars: 5,
        description: '统御大河的水神。在波涛中穿行，掌控着变幻莫测的水域法则。',
        stats: {'生命': 2000, '攻击': 360, '专业': 260, '速度': 150},
        skills: ['大河奔涌', '漩涡禁锢', '水龙吟'],
      ),
      Character(
        name: '祝融',
        image: 'assets/role/Role23.png',
        rarity: Rarity.ssrPlus,
        element: ElementType.fire,
        stars: 5,
        description: '南方火神，掌握世间一切火焰。他降临之处，万物皆会被神火洗礼。',
        stats: {'生命': 2100, '攻击': 520, '防御': 220, '速度': 170},
        skills: ['三昧真火', '火神降临', '焚天灭地'],
      ),
      Character(
        name: '共工',
        image: 'assets/role/Role24.png',
        rarity: Rarity.ssrPlus,
        element: ElementType.water,
        stars: 5,
        description: '水神之后，曾怒触不周山，使天地倾斜。拥有撕裂天地的狂暴水力。',
        stats: {'生命': 3200, '攻击': 460, '防御': 350, '速度': 110},
        skills: ['怒触天柱', '洪荒海啸', '破碎之潮'],
      ),
      Character(
        name: '女娲',
        image: 'assets/role/Role25.png',
        rarity: Rarity.ssrPlus,
        element: ElementType.earth,
        stars: 5,
        description: '造人补天，万物之母。拥有至高无上的创造与治愈之力，是生灵的终极守护者。',
        stats: {'生命': 5000, '攻击': 250, '防御': 500, '速度': 100},
        skills: ['五彩补天', '捏土造人', '万物回春'],
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text(
          '异兽图鉴',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF1A1A1A), Colors.black.withOpacity(0.8)],
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.35,
            crossAxisSpacing: 8,
            mainAxisSpacing: 16,
          ),
          itemCount: characters.length,
          itemBuilder: (context, index) {
            return CharacterCard(character: characters[index]);
          },
        ),
      ),
    );
  }
}

class CharacterCard extends StatelessWidget {
  final Character character;

  const CharacterCard({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                CharacterDetailPage(character: character),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
          ),
        );
      },
      child: ClipPath(
        clipper: CardClipper(),
        child: Container(
          decoration: BoxDecoration(
            gradient: _getRarityGradient(character.rarity),
            boxShadow: [
              BoxShadow(
                color: _getRarityColor(character.rarity).withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Character Image
              Positioned.fill(
                child: Hero(
                  tag: 'char_img_${character.name}_${character.image}',
                  child: Image.asset(
                    character.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Container(color: Colors.grey[800]),
                  ),
                ),
              ),

              // Overlay Gradient
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.transparent,
                        _getRarityColor(character.rarity).withOpacity(0.2),
                        Colors.white.withOpacity(0.8),
                      ],
                      stops: const [0.0, 0.5, 0.7, 1.0],
                    ),
                  ),
                ),
              ),

              // Element Icon
              Positioned(
                top: 4,
                left: 4,
                child: _buildElementIcon(character.element),
              ),

              // Rarity Label
              Positioned(
                top: 4,
                right: 4,
                child: _buildRarityLabel(character.rarity),
              ),

              // Bottom Info (Name and Stars)
              Positioned(
                left: 0,
                right: 0,
                bottom: 20,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Stars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 8,
                          color: index < character.stars
                              ? Colors.orangeAccent
                              : Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Name
                    Text(
                      character.name,
                      style: TextStyle(
                        color: _getRarityColor(
                          character.rarity,
                        ).withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.white.withOpacity(0.5),
                            offset: const Offset(0, 1),
                            blurRadius: 2,
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
      ),
    );
  }

  Widget _buildElementIcon(ElementType type) {
    Color color;
    IconData icon;
    switch (type) {
      case ElementType.water:
        color = Colors.blue;
        icon = Icons.water_drop;
      case ElementType.earth:
        color = Colors.orange;
        icon = Icons.landscape;
      case ElementType.fire:
        color = Colors.red;
        icon = Icons.local_fire_department;
      case ElementType.wind:
        color = Colors.green;
        icon = Icons.air;
    }
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Icon(icon, size: 10, color: Colors.white),
    );
  }

  Widget _buildRarityLabel(Rarity rarity) {
    String text;
    Color color;
    switch (rarity) {
      case Rarity.ssrPlus:
        text = 'SSR+';
        color = Colors.orange;
      case Rarity.ssr:
        text = 'SSR';
        color = Colors.orangeAccent;
      case Rarity.sr:
        text = 'SR';
        color = Colors.purpleAccent;
      case Rarity.r:
        text = 'R';
        color = Colors.blueAccent;
    }
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 10,
        fontWeight: FontWeight.w900,
        fontStyle: FontStyle.italic,
        shadows: const [
          Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 2),
        ],
      ),
    );
  }

  LinearGradient _getRarityGradient(Rarity rarity) {
    switch (rarity) {
      case Rarity.ssrPlus:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
        );
      case Rarity.ssr:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFA500), Color(0xFFFF4500)],
        );
      case Rarity.sr:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFE0B0FF), Color(0xFF8A2BE2)],
        );
      case Rarity.r:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFB0C4DE), Color(0xFF4682B4)],
        );
    }
  }

  Color _getRarityColor(Rarity rarity) {
    switch (rarity) {
      case Rarity.ssrPlus:
        return Colors.orange;
      case Rarity.ssr:
        return Colors.orangeAccent;
      case Rarity.sr:
        return Colors.purple;
      case Rarity.r:
        return Colors.blue;
    }
  }
}

class CardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 10);
    // Top curve
    path.quadraticBezierTo(size.width / 2, 0, size.width, 10);
    path.lineTo(size.width, size.height - 20);
    // Bottom point
    path.lineTo(size.width / 2, size.height);
    path.lineTo(0, size.height - 20);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class CharacterDetailPage extends StatelessWidget {
  final Character character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Glow
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.0,
                  colors: [
                    _getRarityColor(character.rarity).withOpacity(0.2),
                    Colors.black,
                  ],
                ),
              ),
            ),
          ),

          // Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Image Header
              SliverAppBar(
                expandedHeight: 400,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'char_img_${character.name}_${character.image}',
                    child: Container(
                      padding: const EdgeInsets.only(top: 40),
                      child: Image.asset(character.image, fit: BoxFit.contain),
                    ),
                  ),
                ),
              ),

              // Details
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Name and Rarity
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            character.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(width: 12),
                          _buildRarityBadge(character.rarity),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Stars
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 20,
                            color: index < character.stars
                                ? Colors.orangeAccent
                                : Colors.grey.withOpacity(0.3),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Stats Section
                      const Text(
                        '异兽属性',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...character.stats.entries.map(
                        (e) => _buildStatBar(e.key, e.value, character.rarity),
                      ),

                      const SizedBox(height: 32),

                      // Description
                      const Text(
                        '异兽传记',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        character.description,
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Skills
                      const Text(
                        '天赋技能',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: character.skills
                            .map((s) => _buildSkillChip(s, character.rarity))
                            .toList(),
                      ),

                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRarityBadge(Rarity rarity) {
    String text;
    Color color;
    switch (rarity) {
      case Rarity.ssrPlus:
        text = 'SSR+';
        color = Colors.orange;
      case Rarity.ssr:
        text = 'SSR';
        color = Colors.orangeAccent;
      case Rarity.sr:
        text = 'SR';
        color = Colors.purpleAccent;
      case Rarity.r:
        text = 'R';
        color = Colors.blueAccent;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatBar(String label, int value, Rarity rarity) {
    // 假设最大值为 3000
    final double progress = (value / 3000).clamp(0.1, 1.0);
    final color = _getRarityColor(rarity);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
              Text(
                value.toString(),
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: AlwaysStoppedAnimation<Color>(color.withOpacity(0.8)),
              minHeight: 4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String skill, Rarity rarity) {
    final color = _getRarityColor(rarity);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.flash_on, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            skill,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Color _getRarityColor(Rarity rarity) {
    switch (rarity) {
      case Rarity.ssrPlus:
        return Colors.orange;
      case Rarity.ssr:
        return Colors.orangeAccent;
      case Rarity.sr:
        return Colors.purpleAccent;
      case Rarity.r:
        return Colors.blueAccent;
    }
  }
}
