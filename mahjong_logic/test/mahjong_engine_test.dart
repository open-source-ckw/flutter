import 'package:mahjong_logic/logic/mahjong_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Claim Pung rule', () {
    test('Discard opens claim window and detects eligible claimers', () {
      final p0 = PlayerState(hand: [const Tile(Suit.bam, 2)]);
      final p1 = PlayerState(hand: [
        const Tile(Suit.dot, 5),
        const Tile(Suit.dot, 5),
        const Tile(Suit.dot, 5),
      ]);
      final p2 = PlayerState(hand: [
        const Tile(Suit.dot, 5),
        const Tile(Suit.dot, 5),
        const Tile(Suit.bam, 9),
      ]);
      final p3 = PlayerState(hand: [const Tile(Suit.crak, 7)]);

      final state = GameState(players: [p0, p1, p2, p3])..currentPlayer = 1;
      final engine = MahjongEngine(state);

      // Player 1 discards Dot-5
      engine.dispatch(const DiscardAction(1, Tile(Suit.dot, 5)));

      expect(state.phase, Phase.claimWindow);
      expect(state.lastDiscard, const Tile(Suit.dot, 5));
      expect(state.lastDiscardBy, 1);

      // Only player 2 has 2 matching tiles, so only player 2 can claim pung.
      expect(state.pendingClaimers.contains(2), isTrue);
      expect(state.pendingClaimers.contains(0), isFalse);
      expect(state.pendingClaimers.contains(3), isFalse);
    });

    test('Claim pung consumes 2 tiles, creates meld, and transfers turn', () {
      final p0 = PlayerState(hand: []);
      final p1 = PlayerState(hand: [const Tile(Suit.dot, 5)]); // will discard this
      final p2 = PlayerState(hand: [
        const Tile(Suit.dot, 5),
        const Tile(Suit.dot, 5),
        const Tile(Suit.bam, 9),
      ]);
      final p3 = PlayerState(hand: []);

      final state = GameState(players: [p0, p1, p2, p3])..currentPlayer = 1;
      final engine = MahjongEngine(state);

      engine.dispatch(const DiscardAction(1, Tile(Suit.dot, 5)));
      expect(engine.canClaimPung(2), isTrue);

      engine.dispatch(const ClaimPungAction(2));

      expect(state.currentPlayer, 2);
      expect(state.phase, Phase.turnAfterClaim);
      expect(state.lastDiscard, isNull);
      expect(state.pendingClaimers.isEmpty, isTrue);

      // Player 2 had 2 Dot-5 in hand, should now be removed
      expect(p2.hand.where((t) => t == const Tile(Suit.dot, 5)).length, 0);
      expect(p2.melds.length, 1);
      expect(p2.melds.first.type, MeldType.pung);
      expect(p2.melds.first.tiles.length, 3);
      expect(p2.melds.first.tiles.every((t) => t == const Tile(Suit.dot, 5)), isTrue);
      expect(p2.melds.first.claimedFromPlayer, 1);
    });

    test('Cannot claim pung outside claimWindow', () {
      final state = GameState(players: [
        PlayerState(hand: []),
        PlayerState(hand: []),
        PlayerState(hand: [const Tile(Suit.dot, 5), const Tile(Suit.dot, 5)]),
        PlayerState(hand: []),
      ]);

      final engine = MahjongEngine(state);

      expect(engine.canClaimPung(2), isFalse);
    });

    test('Cannot claim pung on a joker discard (rule assumption in engine)', () {
      final p0 = PlayerState(hand: []);
      final p1 = PlayerState(hand: [const Tile(Suit.joker, 0)]);
      final p2 = PlayerState(hand: [
        const Tile(Suit.joker, 0),
        const Tile(Suit.joker, 0),
      ]);
      final p3 = PlayerState(hand: []);

      final state = GameState(players: [p0, p1, p2, p3])..currentPlayer = 1;
      final engine = MahjongEngine(state);

      engine.dispatch(const DiscardAction(1, Tile(Suit.joker, 0)));

      // Engine disallows claiming jokers
      expect(engine.canClaimPung(2), isFalse);
      expect(state.pendingClaimers.contains(2), isFalse);
    });
  });
}
