// mahjong_engine.dart
import 'dart:collection';

enum Suit { bam, crak, dot, wind, dragon, flower, joker }
enum Phase { waitingForDiscard, claimWindow, turnAfterClaim }

class Tile {
  final Suit suit;
  final int rank; // 1-9 for suits, or custom mapping for honors/flowers
  const Tile(this.suit, this.rank);

  @override
  bool operator ==(Object other) =>
      other is Tile && other.suit == suit && other.rank == rank;

  @override
  int get hashCode => Object.hash(suit, rank);

  @override
  String toString() => '${suit.name}:$rank';
}

enum MeldType { pung, kong, chow }

class Meld {
  final MeldType type;
  final List<Tile> tiles;
  final int claimedFromPlayer; // who discarded the claimed tile
  const Meld({
    required this.type,
    required this.tiles,
    required this.claimedFromPlayer,
  });
}

class PlayerState {
  final List<Tile> hand;
  final List<Meld> melds;

  PlayerState({
    List<Tile>? hand,
    List<Meld>? melds,
  })  : hand = hand ?? <Tile>[],
        melds = melds ?? <Meld>[];

  int countInHand(Tile t) => hand.where((x) => x == t).length;

  void removeFromHand(Tile t, int times) {
    var remaining = times;
    for (var i = hand.length - 1; i >= 0 && remaining > 0; i--) {
      if (hand[i] == t) {
        hand.removeAt(i);
        remaining--;
      }
    }
    if (remaining != 0) {
      throw StateError('Tried to remove $times of $t but not enough in hand.');
    }
  }
}

class GameState {
  Phase phase = Phase.waitingForDiscard;

  final List<PlayerState> players;
  int currentPlayer = 0;

  Tile? lastDiscard;
  int? lastDiscardBy;

  // during claimWindow: who can claim, and what
  final Set<int> pendingClaimers = <int>{};

  GameState({required this.players});
}

sealed class Action {
  const Action();
}

class DiscardAction extends Action {
  final int playerIndex;
  final Tile tile;
  const DiscardAction(this.playerIndex, this.tile);
}

class ClaimPungAction extends Action {
  final int claimerIndex;
  const ClaimPungAction(this.claimerIndex);
}

/// A tiny "engine": pure rules + state transitions.
/// Put UI, animations, networking elsewhere.
class MahjongEngine {
  final GameState s;
  MahjongEngine(this.s);

  /// Rule: After a discard, open a claim window for other players who can PUNG.
  /// Pung requirement: claimer has 2 matching tiles in hand + lastDiscard exists.
  bool canClaimPung(int claimerIndex) {
    if (s.phase != Phase.claimWindow) return false;
    if (s.lastDiscard == null) return false;
    if (s.lastDiscardBy == null) return false;
    if (claimerIndex == s.lastDiscardBy) return false;

    final t = s.lastDiscard!;
    // Common rule assumption: jokers usually can't be used to CLAIM the discard as part of pung.
    // You can parameterize this later.
    if (t.suit == Suit.joker) return false;

    return s.players[claimerIndex].countInHand(t) >= 2;
  }

  void dispatch(Action a) {
    switch (a) {
      case DiscardAction():
        _discard(a.playerIndex, a.tile);
      case ClaimPungAction():
        _claimPung(a.claimerIndex);
    }
  }

  void _discard(int playerIndex, Tile tile) {
    if (s.phase != Phase.waitingForDiscard) {
      throw StateError('Not allowed to discard in phase ${s.phase}');
    }
    if (playerIndex != s.currentPlayer) {
      throw StateError('Only current player can discard.');
    }

    final p = s.players[playerIndex];
    p.removeFromHand(tile, 1);

    s.lastDiscard = tile;
    s.lastDiscardBy = playerIndex;

    // Open claim window
    s.phase = Phase.claimWindow;
    s.pendingClaimers.clear();

    for (var i = 0; i < s.players.length; i++) {
      if (i == playerIndex) continue;
      if (canClaimPung(i)) s.pendingClaimers.add(i);
    }

    // If nobody can claim, advance turn immediately
    if (s.pendingClaimers.isEmpty) {
      _advanceTurnAfterNoClaim();
    }
  }

  void _claimPung(int claimerIndex) {
    if (!canClaimPung(claimerIndex)) {
      throw StateError('Player $claimerIndex cannot claim pung right now.');
    }

    final claimedTile = s.lastDiscard!;
    final discarder = s.lastDiscardBy!;

    final claimer = s.players[claimerIndex];

    // Remove 2 matching tiles from claimer hand, add meld including claimed discard.
    claimer.removeFromHand(claimedTile, 2);

    claimer.melds.add(Meld(
      type: MeldType.pung,
      tiles: [claimedTile, claimedTile, claimedTile],
      claimedFromPlayer: discarder,
    ));

    // Claimer becomes current player and must discard next
    s.currentPlayer = claimerIndex;
    s.lastDiscard = null;
    s.lastDiscardBy = null;
    s.pendingClaimers.clear();
    s.phase = Phase.turnAfterClaim;
  }

  void _advanceTurnAfterNoClaim() {
    s.lastDiscard = null;
    s.lastDiscardBy = null;
    s.currentPlayer = (s.currentPlayer + 1) % s.players.length;
    s.phase = Phase.waitingForDiscard;
  }

  /// After a claim, the claimer typically must discard (turnAfterClaim -> waitingForDiscard).
  void beginPostClaimDiscardPhase() {
    if (s.phase != Phase.turnAfterClaim) return;
    s.phase = Phase.waitingForDiscard;
  }
}