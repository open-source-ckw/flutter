// mahjong_flame_game.dart
import 'package:flame/game.dart';
import '../logic/engine.dart';

class MahjongFlameGame extends FlameGame {
  late GameState state;
  late final AmericanMahjongRules rules;

  @override
  Future<void> onLoad() async {
    rules = AmericanMahjongRules();

    // Minimal setup (2 players just for demo)
    state = GameState(
      players: [
        PlayerHand(concealed: [
          const Tile(TileType.suit, "DOT_5"),
          const Tile(TileType.suit, "DOT_5"),
          // ... fill as needed
        ]),
        PlayerHand(concealed: [
          const Tile(TileType.suit, "BAM_2"),
          // ...
        ]),
      ],
      currentPlayer: 0,
      lastDiscard: null,
      lastDiscardPlayer: -1,
    );
  }

  // Example: player taps a tile to discard
  void onTileTapToDiscard(int playerIndex, Tile tile) {
    final action = DiscardAction(playerIndex, tile);
    final res = rules.validate(state, action);
    if (!res.ok) {
      // Show toast/snackbar in Flutter layer; for Flame just log
      print("Invalid: ${res.error}");
      return;
    }
    state = rules.apply(state, action);
  }

  // Example: player taps "Mahj" to claim discard as a pair (only if it wins)
  void onTapClaimPairForMahjong(int playerIndex) {
    final action = ClaimPairForMahjongAction(playerIndex);
    final res = rules.validate(state, action);
    if (!res.ok) {
      print("Invalid: ${res.error}");
      return;
    }
    state = rules.apply(state, action);
    print("Mah Jongg declared by player $playerIndex");
  }
}
