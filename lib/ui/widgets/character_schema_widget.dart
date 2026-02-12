import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/part.dart';
import '../../models/player.dart';
import '../../utils/constants.dart';
import 'painters.dart';

class CharacterSchemaWidget extends StatelessWidget {
  final Player player;
  final Function(PartType type, Part? part)? onSlotTap;
  final bool showLabels;
  final double scale;

  const CharacterSchemaWidget({
    super.key,
    required this.player,
    this.onSlotTap,
    this.showLabels = true,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: Size.infinite,
              painter: BodySchemaPainter(scale: scale),
            ),
            // Using relative positioning based on constraints
            Positioned(
              top: constraints.maxHeight * 0.1,
              child: _buildEquippedSlot(context, PartType.head, '首'),
            ),
            Positioned(
              top: constraints.maxHeight * 0.35,
              child: _buildEquippedSlot(context, PartType.body, '躯'),
            ),
            Positioned(
              bottom: constraints.maxHeight * 0.15,
              child: _buildEquippedSlot(context, PartType.leg, '足'),
            ),
            Positioned(
              right: constraints.maxWidth * 0.1,
              bottom: constraints.maxHeight * 0.3,
              child: _buildEquippedSlot(context, PartType.tail, '尾'),
            ),
            Positioned(
              left: constraints.maxWidth * 0.1,
              bottom: constraints.maxHeight * 0.3,
              child: _buildEquippedSlot(context, PartType.soul, '魂'),
            ),
          ],
        );
      }
    );
  }

  Widget _buildEquippedSlot(BuildContext context, PartType type, String label) {
    final part = player.parts[type];
    final power = part?.power ?? 0;
    final powerColor = part != null ? AppColors.getPowerColor(power) : Colors.grey;

    final double size = 56.0 * scale;
    final double fontSizeChar = 24.0 * scale;
    final double fontSizeLabel = 20.0 * scale;
    final double fontSizePower = 10.0 * scale;

    return GestureDetector(
      onTap: () {
        if (onSlotTap != null) {
          onSlotTap!(type, part);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: part != null ? AppColors.bgPaper : Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: part != null ? powerColor : Colors.grey.withOpacity(0.5),
                width: 2,
              ),
              boxShadow: part != null
                  ? [BoxShadow(color: powerColor.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                  : [],
            ),
            alignment: Alignment.center,
            child: part != null
                ? Text(
                    part.name.substring(0, 1),
                    style: GoogleFonts.maShanZheng(fontSize: fontSizeChar, color: powerColor),
                  )
                : Text(
                    label,
                    style: GoogleFonts.maShanZheng(fontSize: fontSizeLabel, color: Colors.grey.withOpacity(0.5)),
                  ),
          ),
          if (part != null && showLabels)
            Container(
              margin: EdgeInsets.only(top: 4 * scale),
              padding: EdgeInsets.symmetric(horizontal: 6 * scale, vertical: 2 * scale),
              decoration: BoxDecoration(
                color: powerColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '$power',
                style: GoogleFonts.notoSerifSc(fontSize: fontSizePower, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
    );
  }
}
