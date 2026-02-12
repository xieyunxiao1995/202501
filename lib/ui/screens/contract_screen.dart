import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';

class ContractScreen extends StatefulWidget {
  final GameService gameService;

  const ContractScreen({super.key, required this.gameService});

  @override
  State<ContractScreen> createState() => _ContractScreenState();
}

class _ContractScreenState extends State<ContractScreen> {
  // Hardcoded list of contractable beasts
  final List<Map<String, dynamic>> _beasts = [
    {
      'id': 'beast_001',
      'name': '九尾狐',
      'title': '青丘之主',
      'desc': '青丘之山，有兽焉，其状如狐而九尾。',
      'cost': 100,
      'icon': Icons.category,
      'buff': '战斗中每回合恢复 5 点理智',
    },
    {
      'id': 'beast_002',
      'name': '饕餮',
      'title': '贪食之欲',
      'desc': '其状如羊身人面，其目在腋下，虎齿人爪。',
      'cost': 200,
      'icon': Icons.face_retouching_off,
      'buff': '战斗中吸血 10%',
    },
    {
      'id': 'beast_003',
      'name': '混沌',
      'title': '太古四凶',
      'desc': '其状如犬，长毛，四足，似罴而无爪。',
      'cost': 300,
      'icon': Icons.cloud,
      'buff': '战斗开始时获得 20 点护盾',
    },
    {
      'id': 'beast_004',
      'name': '穷奇',
      'title': '惩善扬恶',
      'desc': '状如虎，有翼，食人从首始。',
      'cost': 300,
      'icon': Icons.catching_pokemon,
      'buff': '攻击力提升 15%',
    },
  ];

  void _contractBeast(Map<String, dynamic> beast) {
    final player = widget.gameService.player;
    if (player == null) return;

    if (player.contractedBeasts.contains(beast['id'])) {
      return; // Already contracted
    }

    int cost = beast['cost'];
    if (player.ink < cost) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('墨韵不足，无法契约！')),
      );
      return;
    }

    widget.gameService.consumeInk(cost);
    player.contractedBeasts.add(beast['id']);
    widget.gameService.saveGame();
    setState(() {});
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('成功契约 ${beast['name']}！')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.gameService.player;
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.inkBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('契约神兽', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: 24)),
        centerTitle: true,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                '墨韵: ${player?.ink ?? 0}',
                style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _beasts.length,
        itemBuilder: (context, index) {
          final beast = _beasts[index];
          final isContracted = player?.contractedBeasts.contains(beast['id']) ?? false;

          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EFE6),
              border: Border.all(
                color: isContracted ? AppColors.inkRed : AppColors.woodDark,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.woodLight),
                  ),
                  child: Icon(
                    beast['icon'],
                    size: 40,
                    color: isContracted ? AppColors.inkRed : AppColors.inkBlack,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            beast['name'],
                            style: GoogleFonts.maShanZheng(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.inkBlack,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.inkBlack,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              beast['title'],
                              style: const TextStyle(color: AppColors.bgPaper, fontSize: 10),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        beast['desc'],
                        style: TextStyle(color: AppColors.inkBlack.withOpacity(0.7), fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '契约效果: ${beast['buff']}',
                        style: const TextStyle(color: AppColors.inkRed, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    if (isContracted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.inkRed),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '已契约',
                          style: TextStyle(color: AppColors.inkRed, fontSize: 12),
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: () => _contractBeast(beast),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.inkBlack,
                          foregroundColor: AppColors.bgPaper,
                        ),
                        child: Text('${beast['cost']} 墨'),
                      ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
