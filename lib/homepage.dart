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

// game settings
  bool gamesHasStarted = false;

  void startGame() {
    gamesHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      // a real phusical jump is the same as an upside down parabola
      // this is an quadrantric equation
      height = gravity * time * time + velocity * time;

      setState(() {
        birdY = initialPos - height;
      });

      //check if birtd is dead
      if (birdIsDead()) {
        timer.cancel();
        gamesHasStarted = false;
        _showDialog();
      }

      //keep the time going!
      time += 0.05;
    });
  }

  void resetGame() {
    Navigator.pop(context); // dismises the alert dialog
    setState(() {
      birdY = 0;
      gamesHasStarted = false;
      time = 0;
      initialPos = birdY;
    });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: const Center(
                child: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            )),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    color: Colors.white,
                    child: const Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void jump() {
    setState(() {
      time = 0;
      initialPos = birdY;
    });
  }

  bool birdIsDead() {
    //check if the bird is hitting the top or bottom of the screen
    if (birdY < -1 || birdY > 1) {
      return true;
    }

    //check if the bird is hitting a barrier

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: gamesHasStarted ? jump : startGame,
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
                          ),
                          Container(
                            alignment: const Alignment(0, -0.5),
                            child: Text(
                              gamesHasStarted ? ' ' : 'TAP TO PLAY',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
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
