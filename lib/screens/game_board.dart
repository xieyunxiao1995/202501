import 'package:flutter/material.dart';
import '../models/card_data.dart';
import '../widgets/game_card.dart';
import '../constants.dart';

class GameBoard extends StatelessWidget {
  final List<CardData> cards;
  final Set<int> reachableIndices;
  final Function(CardData, GlobalKey) onCardTap;
  final List<GlobalKey> cardKeys;

  const GameBoard({
    super.key,
    required this.cards,
    required this.reachableIndices,
    required this.onCardTap,
    required this.cardKeys,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: gridCols,
        childAspectRatio: isSmallScreen ? 0.72 : 0.75, // Adjust based on card content
        crossAxisSpacing: isSmallScreen ? 4 : 8,
        mainAxisSpacing: isSmallScreen ? 4 : 8,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        final isReachable = reachableIndices.contains(index);
        final GlobalKey cardKey = cardKeys[index];

        return KeyedSubtree(
          key: cardKey,
          child: GameCard(
            card: card,
            isReachable: isReachable,
            onTap: () => onCardTap(card, cardKey),
          ),
        );
      },
    );
  }
}
