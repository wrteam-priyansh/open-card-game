import 'dart:math';

import 'package:flutter/material.dart';
import 'package:playing_cards/playing_cards.dart';

class PlaygroundScreen extends StatefulWidget {
  PlaygroundScreen({Key? key}) : super(key: key);

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen>
    with TickerProviderStateMixin {
  late AnimationController angleAnimationController =
      AnimationController(vsync: this, duration: Duration(milliseconds: 750));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (angleAnimationController.isCompleted) {
            angleAnimationController.reverse();
          } else {
            angleAnimationController.forward();
          }
        },
      ),
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: angleAnimationController,
              builder: (context, child) {
                double angle = 270 +
                    Tween<double>(begin: 0, end: 90)
                        .animate(CurvedAnimation(
                            parent: angleAnimationController,
                            curve: Curves.easeInOutBack))
                        .value;

                return Opacity(
                  opacity: angleAnimationController.value,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY((pi / 180) * angle),
                    child: Container(
                        width: MediaQuery.of(context).size.width * (0.5),
                        child: PlayingCardView(
                            elevation: 5,
                            card: PlayingCard(Suit.clubs, CardValue.ace))),
                  ),
                );
              },
            ),
          ),
          Center(
            child: AnimatedBuilder(
              animation: angleAnimationController,
              builder: (context, child) {
                double angle = 0 +
                    Tween<double>(begin: 0, end: 90)
                        .animate(CurvedAnimation(
                            parent: angleAnimationController,
                            curve: Curves.easeInOutBack))
                        .value;

                return Opacity(
                  opacity: 1.0 - angleAnimationController.value,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY((pi / 180) * angle),
                    child: Container(
                        width: MediaQuery.of(context).size.width * (0.5),
                        child: PlayingCardView(
                            showBack: true,
                            elevation: 5,
                            card: PlayingCard(Suit.clubs, CardValue.ace))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
