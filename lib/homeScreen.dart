import 'dart:math';

import 'package:card_game_test/models/card.dart';
import 'package:card_game_test/utils.dart';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CardDetails> cards = [];
  //total 6 cards per player 3
  List<CardDetails> cardsInTable = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      initCards();
    });
  }

  void initCards() {
    if (cards.isNotEmpty) {
      cards.clear();
      cardsInTable.clear();
    }
    Random random = Random.secure();
    //
    for (var suit in Suit.values) {
      for (var card in CardValue.values) {
        cards.add(CardDetails(cardValue: card, suit: suit));
      }
    }
    for (var i = 0; i < 6; i++) {
      //
      int selectedIndex = random.nextInt(cards.length);
      cardsInTable.add(cards[selectedIndex]);
      cards.removeAt(selectedIndex);
    }
    setState(() {});
  }

  List<CardDetails> _buildBotCards() {
    List<CardDetails> botCards = [];
    for (var i = 0; i < 6; i++) {
      if (i.isEven) {
        botCards.add(cardsInTable[i]);
      }
    }

    botCards.sort((first, second) =>
        first.cardValue.index.compareTo(second.cardValue.index));
    return botCards;
  }

  List<CardDetails> _buildMyCards() {
    List<CardDetails> myCards = [];
    for (var i = 0; i < 6; i++) {
      if (i.isOdd) {
        myCards.add(cardsInTable[i]);
      }
    }

    myCards.sort((first, second) =>
        first.cardValue.index.compareTo(second.cardValue.index));
    return myCards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        print("Bot Card Rank : ${getCardsRank(_buildBotCards())}");
        print("Player Card Rank : ${getCardsRank(_buildMyCards())}");

        print("--------------");
        print(
            "Winner is ${determineWinner(botCards: _buildBotCards(), myCards: _buildMyCards())}");

        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text(
                    "Winner is ${determineWinner(botCards: _buildBotCards(), myCards: _buildMyCards())}"),
              );
            });
      }),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                //
                initCards();
              },
              icon: Icon(Icons.play_arrow))
        ],
      ),
      body: cardsInTable.isEmpty
          ? Container()
          : Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * (0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        bot,
                        style: TextStyle(fontSize: 30.0),
                      ),
                      Divider(),
                      ..._buildBotCards()
                          .map((e) => Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                width:
                                    MediaQuery.of(context).size.width * (0.32),
                                child: PlayingCardView(
                                    showBack: false,
                                    card: PlayingCard(e.suit, e.cardValue)),
                              ))
                          .toList()
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(border: Border(left: BorderSide())),
                  width: MediaQuery.of(context).size.width * (0.5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        player,
                        style: TextStyle(fontSize: 30.0),
                      ),
                      Divider(),
                      ..._buildMyCards()
                          .map((e) => Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 5.0),
                                width:
                                    MediaQuery.of(context).size.width * (0.32),
                                child: PlayingCardView(
                                    showBack: false,
                                    card: PlayingCard(e.suit, e.cardValue)),
                              ))
                          .toList()
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
