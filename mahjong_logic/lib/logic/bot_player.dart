// bot_player.dart
import 'mahjong_engine.dart';

class BotPlayer {
  static Action? pickAction(int botIndex, GameState s) {
    // 1) If claim window is open, try a pung claim if possible.
    if (s.phase == Phase.claimWindow) {
      final engine = MahjongEngine(s);
      if (engine.canClaimPung(botIndex)) {
        return ClaimPungAction(botIndex);
      }
      // no claim -> engine will advance turn when discard resolves (in your engine flow)
      return null;
    }

    // 2) If it's bot's discard phase, discard something.
    if (s.phase == Phase.waitingForDiscard && s.currentPlayer == botIndex) {
      final hand = s.players[botIndex].hand;
      if (hand.isEmpty) return null;

      // Basic heuristic:
      // - Keep jokers
      // - Keep pairs/triples
      // - Discard singletons first
      Tile best = hand.first;
      int bestScore = 1 << 30;

      for (final t in hand) {
        final count = hand.where((x) => x == t).length;
        final isJoker = t.suit == Suit.joker;

        // Lower score = more disposable
        final score = (isJoker ? 1000 : 0) + (count >= 2 ? 500 : 0);
        if (score < bestScore) {
          bestScore = score;
          best = t;
        }
      }
      return DiscardAction(botIndex, best);
    }

    return null;
  }
}
