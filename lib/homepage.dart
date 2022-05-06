import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_teste/bird.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //bird variables
  static double birdY = 0;
  double initialPos = birdY;
  double height = 0;
  double time = 0;
  double gravity = -4.9; // gravity strengh
  double velocity = 2.8; //jump strengh

  void jump() {
    Timer.periodic(Duration(milliseconds: 60), (timer) {
      // a real phusical jump is the same as an upside down parabola
      // this is an quadrantric equation
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      //check if birtd is dead
      if (birdY < -1) {
        timer.cancel();
      }

      //keep the time going!
      time += 0.05;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: jump,
        child: Scaffold(
          body: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                          Color(0xFF5666EC),
                          Color(0xFF807BE2),
                          Color(0xFFA084D8),
                          Color(0xFFC884DB),
                        ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter)),
                    child: Center(
                      child: Stack(
                        children: [
                          MyBird(
                            birdY: birdY,
                          )
                        ],
                      ),
                    )),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color(0xFFFFA8D2),
                    Color(0xFFE681AD),
                    Color(0xFFE164B2),
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                ),
              ),
            ],
          ),
        ));
  }
}
