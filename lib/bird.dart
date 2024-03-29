// ignore_for_file: prefer_typing_uninitialized_variables

import "package:flutter/material.dart";

class MyBird extends StatelessWidget {
  final birdY;
  final double birdWidth; // normal double value for width
  final double birdHeight; // out of 2, 2 being the entire height of the screen

  const MyBird(
      {Key? key, this.birdY, required this.birdWidth, required this.birdHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(0, (2 * birdY + birdHeight) / (2 - birdHeight)),
      child: Image.asset(
        'assets/images/dvalin.gif',
        width: MediaQuery.of(context).size.height * birdWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * birdHeight / 2,
        fit: BoxFit.fill,
        //height: 140,
        //width: 140
      ),
    );
  }
}
