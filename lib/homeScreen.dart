import 'dart:math';

import 'package:card_game_test/models/card.dart';
import 'package:card_game_test/utils.dart';
import 'package:card_game_test/widgets/cardContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<CardDetails> cards = [];
  //total 6 cards per player 3
  List<CardDetails> cardsInTable = [];

  List<AnimationController> botCardsAnimationControllers = [];

  List<AnimationController> playerCardsAnimationControllers = [];

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 3; i++) {
      playerCardsAnimationControllers.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 750)));

      botCardsAnimationControllers.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 750)));
    }

    Future.delayed(Duration.zero, () {
      initCards();
    });
  }

  @override
  void dispose() {
    for (var i = 0; i < 3; i++) {
      //
      playerCardsAnimationControllers[i].dispose();

      botCardsAnimationControllers[i].dispose();
    }
    super.dispose();
  }

  Future<void> initCards() async {
    if (cards.isNotEmpty) {
      cards = [];
      cardsInTable = [];

      for (var i = 0; i < 3; i++) {
        //
        playerCardsAnimationControllers[i].value = 0;

        botCardsAnimationControllers[i].value = 0;
      }

      setState(() {});
    }
    Random random = Random.secure();
    //
    for (var suit in Suit.values) {
      for (var card in CardValue.values) {
        cards.add(CardDetails(cardValue: card, suit: suit));
      }
    }
    for (var i = 0; i < 6; i++) {
      int selectedIndex = random.nextInt(cards.length);
      cardsInTable.add(cards[selectedIndex]);
      cards.removeAt(selectedIndex);
    }
    setState(() {});
  }

  Future<void> showWinner() async {
    bool canShowWinner = true;

    for (var animationController in playerCardsAnimationControllers) {
      if (!animationController.isCompleted) {
        canShowWinner = false;
        break;
      }
    }

    if (!canShowWinner) {
      return;
    }

    await Future.delayed(Duration(milliseconds: 1000));
    showDialog(
        context: context,
        builder: (_) {
          return WillPopScope(
            onWillPop: () {
              return Future.value(false);
            },
            child: AlertDialog(
              actions: [
                CupertinoButton(
                    child: Text("Play again"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      initCards();
                    }),
                CupertinoButton(
                    child: Text("Exit"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
              title: Text(determineWinner(
                          botCards: _buildBotCards(sortCards: true),
                          myCards: _buildMyCards(sortCards: true)) ==
                      player
                  ? "You won"
                  : "Better luck next time"),
            ),
          );
        });
  }

  List<CardDetails> _buildBotCards({required bool sortCards}) {
    List<CardDetails> botCards = [];
    if (cardsInTable.isEmpty) return [];
    for (var i = 0; i < 6; i++) {
      if (i.isEven) {
        botCards.add(cardsInTable[i]);
      }
    }

    if (sortCards) {
      botCards.sort((first, second) =>
          first.cardValue.index.compareTo(second.cardValue.index));
    }

    return botCards;
  }

  List<CardDetails> _buildMyCards({required bool sortCards}) {
    List<CardDetails> myCards = [];

    if (cardsInTable.isEmpty) return [];
    for (var i = 0; i < 6; i++) {
      if (i.isOdd) {
        myCards.add(cardsInTable[i]);
      }
    }

    if (sortCards) {
      myCards.sort((first, second) =>
          first.cardValue.index.compareTo(second.cardValue.index));
    }

    return myCards;
  }

  List<Widget> _buildCardsContainer({required bool forPlayer}) {
    List<Widget> cards = [];
    final cardDetails = forPlayer
        ? _buildMyCards(sortCards: false)
        : _buildBotCards(sortCards: false);

    for (var i = 0; i < cardDetails.length; i++) {
      cards.add(
        GestureDetector(
          onTap: () async {
            if (forPlayer) {
              //
              await playerCardsAnimationControllers[i].forward();

              await botCardsAnimationControllers[i].forward();

              showWinner();
            }
          },
          child: CardContainer(
              animationController: forPlayer
                  ? playerCardsAnimationControllers[i]
                  : botCardsAnimationControllers[i],
              cardDetails: cardDetails[i]),
        ),
      );
    }

    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open Cards"),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * (0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  bot,
                  style: TextStyle(fontSize: 30.0),
                ),
                Divider(),
                ..._buildCardsContainer(forPlayer: false)
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border(left: BorderSide())),
            width: MediaQuery.of(context).size.width * (0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Text(
                  player,
                  style: TextStyle(fontSize: 30.0),
                ),
                Divider(),
                ..._buildCardsContainer(forPlayer: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
