import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/role.dart';
import '../../utils/constants.dart';
import '../widgets/background_scaffold.dart';

class RoleDetailScreen extends StatelessWidget {
  final Role role;

  const RoleDetailScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return BackgroundScaffold(
      // Use a generic background or specific one if available
      backgroundImage: AppAssets.bgMistyBambooForest,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 20),
            color: AppColors.inkBlack,
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.inkBlack),
        title: Text(
          role.name,
          style: GoogleFonts.maShanZheng(
            color: AppColors.inkBlack,
            fontSize: isSmallScreen ? 24 : 32,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Character Image Area
            SizedBox(
              height: isTablet ? 600 : 400,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative circle/aura
                  Container(
                    width: isTablet ? 500 : 300,
                    height: isTablet ? 500 : 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          role.elementColor.withOpacity(0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  // Character Image
                  Hero(
                    tag: 'role_image_${role.id}',
                    child: Image.asset(
                      role.assetPath,
                      fit: BoxFit.contain,
                      height: isTablet ? 550 : 380,
                    ),
                  ),
                  // Element Icon (Bottom Left) - Moved from Top Left to avoid AppBar back button overlap
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                        border: Border.all(color: role.elementColor, width: 2),
                      ),
                      child: Text(
                        _getElementChar(role.element),
                        style: GoogleFonts.maShanZheng(
                          fontSize: 24,
                          color: role.elementColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Rarity Badge (Top Right)
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.inkRed,
                            AppColors.inkRed.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        role.rarityLabel,
                        style: GoogleFonts.notoSerifSc(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Info Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.bgPaper.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.woodDark.withOpacity(0.3)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            role.title,
                            style: GoogleFonts.notoSerifSc(
                              fontSize: 16,
                              color: AppColors.inkBlack.withOpacity(0.6),
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            role.name,
                            style: GoogleFonts.maShanZheng(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.inkBlack,
                            ),
                          ),
                        ],
                      ),
                      // Stars
                      Row(
                        children: List.generate(
                          role.stars,
                          (index) =>
                              Icon(Icons.star, color: Colors.amber, size: 24),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 32, thickness: 1),
                  Text(
                    '【角色传记】',
                    style: GoogleFonts.maShanZheng(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.woodDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    role.description,
                    style: GoogleFonts.notoSerifSc(
                      fontSize: 16,
                      height: 1.8,
                      color: AppColors.inkBlack.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Attributes (Mockup)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildAttribute(Icons.favorite, '生命', 'A'),
                      _buildAttribute(Icons.flash_on, '攻击', 'S'),
                      _buildAttribute(Icons.shield, '防御', 'B'),
                      _buildAttribute(Icons.speed, '速度', 'A'),
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

  Widget _buildAttribute(IconData icon, String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.woodLight.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.woodDark),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.notoSerifSc(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: GoogleFonts.maShanZheng(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String _getElementChar(RoleElement element) {
    switch (element) {
      case RoleElement.metal:
        return '金';
      case RoleElement.wood:
        return '木';
      case RoleElement.water:
        return '水';
      case RoleElement.fire:
        return '火';
      case RoleElement.earth:
        return '土';
      case RoleElement.wind:
        return '风';
      case RoleElement.thunder:
        return '雷';
      case RoleElement.yin:
        return '阴';
      case RoleElement.yang:
        return '阳';
    }
  }
}
