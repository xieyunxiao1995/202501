// 只有局部需要修改，这里提供完整的 combat_map_view.dart 保证覆盖运行不报错
import 'package:flutter/material.dart' hide Hero;
import '../state/game_state.dart';
import '../widgets/game_background.dart';
import '../models/models.dart';
import '../constants.dart';
import 'combat_engine_view.dart';

enum CombatStage { map, setup }

class CombatMapView extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onSave;

  const CombatMapView({
    super.key,
    required this.gameState,
    required this.onSave,
  });

  @override
  State<CombatMapView> createState() => _CombatMapViewState();
}

class _CombatMapViewState extends State<CombatMapView> {
  CombatStage _combatStage = CombatStage.map;
  Stage? _selectedStage;
  List<String> _tempTeam = [];

  @override
  void initState() {
    super.initState();
    _tempTeam = List.from(widget.gameState.team);
  }

  void _onStageSelected(Stage stage) => setState(() {
    _selectedStage = stage;
    _combatStage = CombatStage.setup;
  });
  void _onBackToMap() => setState(() {
    _selectedStage = null;
    _combatStage = CombatStage.map;
  });

  void _toggleTeamMember(String uid) {
    setState(() {
      if (_tempTeam.contains(uid)) {
        _tempTeam.remove(uid);
      } else if (_tempTeam.length < 5) {
        _tempTeam.add(uid);
      }
    });
  }

  int _calculateTeamCombatPower() {
    return _tempTeam
        .map((uid) => widget.gameState.getHero(uid)?.combatPower ?? 0)
        .fold(0, (a, b) => a + b);
  }

  void _startCombat() {
    if (_tempTeam.isEmpty) return;
    widget.gameState.team = List.from(_tempTeam);
    widget.onSave();

    final playerTeam = _tempTeam
        .map((uid) => widget.gameState.getHero(uid))
        .whereType<Hero>()
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CombatEngineView(
          playerTeam: playerTeam,
          selectedStage: _selectedStage!,
          onCombatEnd: () {
            Navigator.of(context).pop();
            setState(() {
              _combatStage = CombatStage.map;
              _selectedStage = null;
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('combat_map'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('combat_map'),
      child: SafeArea(
        child: _combatStage == CombatStage.map
            ? _buildStageSelectionView()
            : _buildTeamSetupView(),
      ),
    );
  }

  Widget _buildStageSelectionView() {
    return Container(
      child: Column(
        children: [
          const SizedBox(height: 24),
          const Text(
            '世界探険',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xffe8c06a),
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '挑戦するエリアを選択してください',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 80),
              itemCount: STAGES.length,
              itemBuilder: (context, index) => _buildStageCard(STAGES[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStageCard(Stage stage) {
    return GestureDetector(
      onTap: () => _onStageSelected(stage),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff2a2a3a),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xff3a3a5a), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stage.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '推奨レベル：Lv.${stage.recLevel}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.5),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamSetupView() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff2a2d36), Color(0xff1a1c23)],
        ),
      ),
      child: Column(
        children: [
          _buildSetupHeader(),
          _buildTeamSlots(),
          _buildCombatPowerDisplay(),
          const SizedBox(height: 16),
          Expanded(child: _buildInventoryList()),
          Padding(
            padding: const EdgeInsets.only(bottom: 100),
            child: _buildStartButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
            onPressed: _onBackToMap,
          ),
          Text(
            _selectedStage?.name ?? '',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildTeamSlots() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          final hero = index < _tempTeam.length
              ? widget.gameState.getHero(_tempTeam[index])
              : null;
          return _buildTeamSlot(hero);
        }),
      ),
    );
  }

  Widget _buildTeamSlot(Hero? hero) {
    return GestureDetector(
      onTap: () {
        if (hero != null) _toggleTeamMember(hero.uid);
      },
      child: Container(
        width: 60,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xff1a1c23),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: hero != null
                ? _getRarityColor(hero.rarity)
                : Colors.grey.shade600,
            width: 2,
          ),
        ),
        child: hero != null
            ? Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.asset(
                      hero.image.isNotEmpty
                          ? hero.image
                          : _getImageFromTemplate(hero.templateId),
                      fit: BoxFit.cover,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ],
              )
            : const Icon(Icons.add, color: Colors.grey, size: 28),
      ),
    );
  }

  Widget _buildCombatPowerDisplay() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xffb45309)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Color(0xffeab308),
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '総戦闘力：${_calculateTeamCombatPower()}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xffeab308),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: widget.gameState.inventory.length,
        itemBuilder: (context, index) {
          final hero = widget.gameState.inventory[index];
          return _buildInventoryHeroCard(hero, _tempTeam.contains(hero.uid));
        },
      ),
    );
  }

  Widget _buildInventoryHeroCard(Hero hero, bool isSelected) {
    final rColor = _getRarityColor(hero.rarity);
    final heroImage = hero.image.isNotEmpty
        ? hero.image
        : _getImageFromTemplate(hero.templateId);

    return GestureDetector(
      onTap: () => _toggleTeamMember(hero.uid),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Colors.green : rColor,
            width: isSelected ? 3 : 2,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  heroImage,
                  fit: BoxFit.cover,
                ),
              ),
              if (isSelected)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 32,
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black87,
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Lv.${hero.level}',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStartButton() {
    final canStart = _tempTeam.isNotEmpty;
    return GestureDetector(
      onTap: canStart ? _startCombat : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: canStart ? Colors.redAccent : Colors.grey.shade700,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_fire_department,
              color: canStart ? Colors.white : Colors.white54,
            ),
            const SizedBox(width: 8),
            Text(
              '出撃',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: canStart ? Colors.white : Colors.white54,
                letterSpacing: 4,
              ),
            ),
          ],
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
}
