// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';

class MyBarrier extends StatelessWidget {
  final barrierWidth; // out of 2, where 2 is the width of the screen
  final barrierHeight; // proportion of the screenheight
  final barrierX;
  final bool isThisBottomBarrier;

  const MyBarrier(
      {Key? key,
      this.barrierHeight,
      this.barrierWidth,
      required this.isThisBottomBarrier,
      this.barrierX})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment((2 * barrierX + barrierWidth) / (2 - barrierWidth),
          isThisBottomBarrier ? 1 : -1),
      child: Container(
        color: const Color(0xFF5666EC),
        width: MediaQuery.of(context).size.width * barrierWidth / 2,
        height: MediaQuery.of(context).size.height * 3 / 4 * barrierHeight / 2,
      ),
    );
  }
}
