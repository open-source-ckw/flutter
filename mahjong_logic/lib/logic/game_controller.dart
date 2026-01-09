// game_controller.dart
import 'package:flutter/foundation.dart';
import 'bot_player.dart';
import 'mahjong_engine.dart';

class GameController extends ChangeNotifier {
  late final GameState state;
  late final MahjongEngine engine;

  // Who is human? say player 0 is human, 1-3 are bots
  final int humanIndex = 0;

  GameController() {
    state = GameState(players: List.generate(4, (_) => PlayerState()));
    engine = MahjongEngine(state);
  }

  void startNewGame() {
    // TODO: build wall, shuffle, deal (engine should do this, or a helper).
    // For now assume you fill players’ hands and set currentPlayer.
    state.phase = Phase.waitingForDiscard;
    state.currentPlayer = 0; // dealer etc.
    notifyListeners();

    _maybeRunBots(); // if a bot starts, let it play
  }

  void userDiscard(Tile tile) {
    if (state.currentPlayer != humanIndex) return;
    engine.dispatch(DiscardAction(humanIndex, tile));
    notifyListeners();

    _resolveClaimsAndContinue();
  }

  void _resolveClaimsAndContinue() {
    // For now, simple: if someone can claim pung, let bots decide.
    // Later: add priority rules (mahjong win > kong > pung > chow etc).
    _maybeRunBots();
  }

  void _maybeRunBots() async {
    // Let bots play until it becomes the human’s turn again.
    while (state.currentPlayer != humanIndex) {
      await Future.delayed(const Duration(milliseconds: 600)); // animation pacing
      // Future.delayed is standard Dart/Flutter. :contentReference[oaicite:2]{index=2}

      final botIndex = state.currentPlayer;
      final action = BotPlayer.pickAction(botIndex, state);

      if (action == null) break;
      engine.dispatch(action);
      notifyListeners();

      // If a bot claimed and now must discard, move phase forward:
      if (state.phase == Phase.turnAfterClaim) {
        engine.beginPostClaimDiscardPhase();
        notifyListeners();
      }
    }
  }
}
