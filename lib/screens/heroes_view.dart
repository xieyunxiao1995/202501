import 'package:flutter/material.dart' hide Hero;
import '../models/models.dart';
import '../constants.dart';
import '../state/game_state.dart';
import '../widgets/game_background.dart';

class HeroesView extends StatelessWidget {
  final GameState gameState;
  final Function(Hero) onHeroSelected;

  const HeroesView({
    super.key,
    required this.gameState,
    required this.onHeroSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('heroes'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('heroes'),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  const Text(
                    '英雄一覧',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      border: Border.all(
                        color: Colors.amber.shade700,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${gameState.inventory.length}',
                      style: const TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: const Icon(
                      Icons.filter_list_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: gameState.inventory.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.group_off_rounded,
                            size: 64,
                            color: Colors.white24,
                          ),
                          SizedBox(height: 16),
                          Text(
                            '英雄がいません。旅館で召喚しましょう',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: 100,
                      ),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.72,
                          ),
                      itemCount: gameState.inventory.length,
                      itemBuilder: (context, index) {
                        return _buildHeroCard(gameState.inventory[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard(Hero hero) {
    final faction = FACTIONS[hero.faction]!;
    final rarityColor = _getRarityColor(hero.rarity);
    // 获取英雄图片（如果为空则从模板获取）
    final heroImage = hero.image.isNotEmpty
        ? hero.image
        : _getImageFromTemplate(hero.templateId);

    return GestureDetector(
      onTap: () => onHeroSelected(hero),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: rarityColor.withOpacity(0.8), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: rarityColor.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              // 英雄图片
              Positioned.fill(
                child: Image.asset(
                  heroImage,
                  fit: BoxFit.cover,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      border: Border(
                        top: BorderSide(color: rarityColor.withOpacity(0.5)),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) => Icon(
                              Icons.star_rounded,
                              size: 10,
                              color: index < hero.stars
                                  ? Colors.amber
                                  : Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          hero.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Lv.${hero.level}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getFactionColor(faction.type),
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    faction.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: rarityColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    hero.rarity.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRarityColor(RarityType rarity) {
    switch (rarity) {
      case RarityType.UR:
        return const Color(0xffef4444);
      case RarityType.SSR:
        return const Color(0xfff97316);
      case RarityType.SR:
        return const Color(0xffa855f7);
      case RarityType.R:
        return const Color(0xff3b82f6);
    }
  }

  String _getImageFromTemplate(String templateId) {
    final template = HERO_TEMPLATES.firstWhere(
      (t) => t.id == templateId,
      orElse: () => HERO_TEMPLATES.first,
    );
    return template.image.isEmpty ? HERO_TEMPLATES.first.image : template.image;
  }

  Color _getFactionColor(FactionType faction) {
    switch (faction) {
      case FactionType.fire:
        return const Color(0xffdc2626);
      case FactionType.water:
        return const Color(0xff2563eb);
      case FactionType.wind:
        return const Color(0xff16a34a);
      case FactionType.light:
        return const Color(0xffeab308);
      case FactionType.dark:
        return const Color(0xff9333ea);
    }
  }
}
