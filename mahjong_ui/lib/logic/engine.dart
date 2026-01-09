// engine.dart
// Minimal example: validate "claim discard as a pair ONLY if it completes Mah Jongg"
// and "no joker in pair".

enum TileType { suit, wind, dragon, flower, joker }

class Tile {
  final TileType type;
  final String code; // e.g. "DOT_5", "BAM_2", "DRAGON_RED", "WIND_E", "JOKER"

  const Tile(this.type, this.code);

  bool get isJoker => type == TileType.joker;

  @override
  bool operator ==(Object other) => other is Tile && other.type == type && other.code == code;

  @override
  int get hashCode => Object.hash(type, code);

  @override
  String toString() => code;
}

class PlayerHand {
  final List<Tile> concealed; // tiles in hand (not exposed)
  final List<List<Tile>> exposedMelds; // pungs/kongs/etc.

  PlayerHand({
    required List<Tile> concealed,
    List<List<Tile>>? exposedMelds,
  })  : concealed = List.of(concealed),
        exposedMelds = exposedMelds == null ? <List<Tile>>[] : exposedMelds.map(List.of).toList();
}

class GameState {
  final List<PlayerHand> players;
  final int currentPlayer;
  final Tile? lastDiscard;
  final int lastDiscardPlayer; // who discarded lastDiscard

  GameState({
    required this.players,
    required this.currentPlayer,
    required this.lastDiscard,
    required this.lastDiscardPlayer,
  });

  GameState copyWith({
    List<PlayerHand>? players,
    int? currentPlayer,
    Tile? lastDiscard,
    int? lastDiscardPlayer,
  }) {
    return GameState(
      players: players ?? this.players,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      lastDiscard: lastDiscard ?? this.lastDiscard,
      lastDiscardPlayer: lastDiscardPlayer ?? this.lastDiscardPlayer,
    );
  }
}

/// --- Actions ---
sealed class GameAction {}

class DiscardAction extends GameAction {
  final int playerIndex;
  final Tile tile;
  DiscardAction(this.playerIndex, this.tile);
}

class ClaimPairForMahjongAction extends GameAction {
  final int claimerIndex;
  ClaimPairForMahjongAction(this.claimerIndex);
}

/// --- Validation result ---
class ValidationResult {
  final bool ok;
  final String? error;
  const ValidationResult.ok() : ok = true, error = null;
  const ValidationResult.err(this.error) : ok = false;
}

/// --- RuleSet interface ---
abstract class RuleSet {
  ValidationResult validate(GameState state, GameAction action);
  GameState apply(GameState state, GameAction action);
}

/// --- American MJ minimal ruleset containing our example rule ---
class AmericanMahjongRules implements RuleSet {
  @override
  ValidationResult validate(GameState state, GameAction action) {
    return switch (action) {
      DiscardAction a => _validateDiscard(state, a),
      ClaimPairForMahjongAction a => _validateClaimPairForMahjong(state, a),
      _ => const ValidationResult.err("Unknown action"),
    };
  }

  @override
  GameState apply(GameState state, GameAction action) {
    // Only apply after validate() returns ok.
    return switch (action) {
      DiscardAction a => _applyDiscard(state, a),
      ClaimPairForMahjongAction a => _applyClaimPairForMahjong(state, a),
      _ => state,
    };
  }

  ValidationResult _validateDiscard(GameState state, DiscardAction a) {
    if (a.playerIndex != state.currentPlayer) {
      return const ValidationResult.err("Not your turn to discard.");
    }
    final hand = state.players[a.playerIndex];
    if (!hand.concealed.contains(a.tile)) {
      return const ValidationResult.err("You don't have that tile.");
    }
    return const ValidationResult.ok();
  }

  GameState _applyDiscard(GameState state, DiscardAction a) {
    final players = state.players.map((h) => PlayerHand(concealed: h.concealed, exposedMelds: h.exposedMelds)).toList();
    players[a.playerIndex].concealed.remove(a.tile);

    return state.copyWith(
      players: players,
      lastDiscard: a.tile,
      lastDiscardPlayer: a.playerIndex,
      // turn advances in your real game; omitted here for focus
    );
  }

  /// THE EXAMPLE RULE:
  /// - You cannot claim a discard to form a pair unless that claim completes Mah Jongg.
  /// - Jokers cannot be used in a pair.
  ValidationResult _validateClaimPairForMahjong(GameState state, ClaimPairForMahjongAction a) {
    final discard = state.lastDiscard;
    if (discard == null) return const ValidationResult.err("No discard to claim.");
    if (a.claimerIndex == state.lastDiscardPlayer) {
      return const ValidationResult.err("You cannot claim your own discard.");
    }
    if (discard.isJoker) {
      return const ValidationResult.err("You cannot claim a Joker.");
    }

    final hand = state.players[a.claimerIndex];
    final countInHand = hand.concealed.where((t) => t == discard).length;

    // To make a pair with discard, you must already have 1 matching tile in concealed.
    if (countInHand < 1) {
      return const ValidationResult.err("You don't have the matching tile to form the pair.");
    }

    // Now: the critical restriction. Pair-claim is only allowed if it completes a winning hand.
    // We'll simulate by checking a solver.
    final simulated = List<Tile>.of(hand.concealed)..add(discard);

    final wins = _isMahjongWinningHand(simulated, exposed: hand.exposedMelds);
    if (!wins) {
      return const ValidationResult.err("Pair claim allowed only if it completes Mah Jongg.");
    }

    return const ValidationResult.ok();
  }

  GameState _applyClaimPairForMahjong(GameState state, ClaimPairForMahjongAction a) {
    final discard = state.lastDiscard!;
    final players = state.players.map((h) => PlayerHand(concealed: h.concealed, exposedMelds: h.exposedMelds)).toList();

    players[a.claimerIndex].concealed.add(discard);

    // In a real game you'd set: winner, end state, settlement, etc.
    return state.copyWith(
      players: players,
      lastDiscard: null,
      lastDiscardPlayer: -1,
    );
  }

  /// Stub: replace with your real NMJL-card pattern solver.
  /// This is intentionally minimal to show where the "hand validation" hooks in.
  bool _isMahjongWinningHand(List<Tile> concealed, {required List<List<Tile>> exposed}) {
    // For demo: pretend "winning" means you have any one pair (non-joker) AND at least 14 total tiles.
    // DO NOT use this as real logic. It's a placeholder.
    if (concealed.length + exposed.expand((x) => x).length < 14) return false;

    final counts = <Tile, int>{};
    for (final t in concealed) {
      counts[t] = (counts[t] ?? 0) + 1;
    }
    final hasNonJokerPair = counts.entries.any((e) => !e.key.isJoker && e.value >= 2);
    return hasNonJokerPair;
  }
}
