import 'package:flutter/material.dart';
import '../models/card_data.dart';
import '../models/enums.dart';
import '../constants.dart';
import '../utils/asset_helper.dart';

class GameCard extends StatefulWidget {
  final CardData card;
  final bool isReachable;
  final VoidCallback onTap;

  const GameCard({
    super.key,
    required this.card,
    required this.isReachable,
    required this.onTap,
  });

  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.card.type == CardType.hero) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(GameCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card.type == CardType.hero) {
      if (!_pulseController.isAnimating) {
        _pulseController.repeat(reverse: true);
      }
    } else {
      if (_pulseController.isAnimating) {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _getAffixName(Affix affix) {
    switch (affix) {
      case Affix.heavy: return "重击";
      case Affix.sharp: return "锋利";
      case Affix.toxic: return "剧毒";
      case Affix.burning: return "灼烧";
      case Affix.cursed: return "诅咒";
      default: return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    // If not flipped and not reachable, show card back (dimmed)
    // If not flipped and reachable, show card back (highlighted)
    // If flipped, show card content.

    final bool isContentVisible = widget.card.isFlipped || widget.card.isRevealed;
    
    // Rarity Colors
    final Color borderColor = rarityColors[widget.card.rarity] ?? Colors.grey;
    final Color bgColor = rarityBgColors[widget.card.rarity] ?? Color(0xFF1F2937);

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: widget.card.type == CardType.hero ? _pulseAnimation.value : 1.0,
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isContentVisible ? bgColor : (widget.isReachable ? Colors.grey[800] : Colors.grey[900]),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isContentVisible 
                  ? borderColor 
                  : (widget.isReachable ? Colors.yellow.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.3)),
              width: isContentVisible ? 2 : 1,
            ),
            boxShadow: isContentVisible
                ? [BoxShadow(color: borderColor.withValues(alpha: 0.3), blurRadius: 8, spreadRadius: 1)]
                : [],
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
            child: isContentVisible
                ? Container(
                    key: ValueKey(widget.card.id),
                    alignment: Alignment.center,
                    child: _buildCardContent(context, borderColor),
                  )
                : Container(
                    key: ValueKey("back_${widget.isReachable}"),
                    alignment: Alignment.center,
                    child: _buildCardBack(context),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent(BuildContext context, Color color) {
    final imagePath = AssetHelper.getCardImage(widget.card);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (widget.card.isBoss)
          Text(
            "大妖",
            style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        if (imagePath != null)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Text(
                    widget.card.icon,
                    style: TextStyle(fontSize: 32),
                  );
                },
              ),
            ),
          )
        else
          Text(
            widget.card.icon,
            style: TextStyle(fontSize: 32),
          ),
        SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: Text(
            widget.card.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 2,
            ),
          ),
        if (widget.card.value > 0)
          Text(
            "${widget.card.value}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        if (widget.card.affix != Affix.none)
          Text(
            _getAffixName(widget.card.affix),
            style: TextStyle(color: Colors.purpleAccent, fontSize: 10, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }

  Widget _buildCardBack(BuildContext context) {
    return Center(
      child: widget.isReachable
          ? Icon(Icons.touch_app, color: Colors.white24, size: 24)
          : SizedBox(),
    );
  }
}
