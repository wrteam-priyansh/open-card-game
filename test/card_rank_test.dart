import 'package:card_game_test/models/card.dart';
import 'package:card_game_test/utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playing_cards/playing_cards.dart';

void main() {
  test("Test rank of given cards", () {
    expect(
        getCardsRank([
          CardDetails(cardValue: CardValue.ace, suit: Suit.clubs),
          CardDetails(cardValue: CardValue.ace, suit: Suit.spades),
          CardDetails(cardValue: CardValue.ace, suit: Suit.diamonds),
        ]),
        CardsRank.triple);

    expect(
        getCardsRank([
          CardDetails(cardValue: CardValue.two, suit: Suit.clubs),
          CardDetails(cardValue: CardValue.three, suit: Suit.spades),
          CardDetails(cardValue: CardValue.ace, suit: Suit.diamonds),
        ]),
        CardsRank.sequence);
  });
}
