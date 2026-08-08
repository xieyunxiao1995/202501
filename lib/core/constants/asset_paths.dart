/// Local visual resources bundled with the game.  Face cards fall back to the
/// painted card view when a source pack uses a different naming convention.
class CardAssets {
  CardAssets._();

  static const String cardBack = 'assets/卡面背/icon_0001.png';

  static final List<String> facePaths = List<String>.generate(
    52,
    (index) => 'assets/牌面/icon_${(index + 1).toString().padLeft(4, '0')}.png',
    growable: false,
  );

  static String faceAt(int index) => facePaths[index % facePaths.length];
}
