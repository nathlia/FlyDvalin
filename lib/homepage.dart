import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_teste/barrier.dart';
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
  double gravity = -4.9; // gravity strength
  double velocity = 2.8; //jump strength
  double birdWidth = 0.3; //out of 2, 2 being the entire width of the screen
  double birdHeight = 0.3; //out of 2, 2 being the entire height of the screen
  int score = 0;
  int bestScore = 0;

// game settings
  bool gamesHasStarted = false;

// barrier variables
  static List<double> barrierX = [2, 2 + 1.5];
  static double barrierWidth = 0.5;
  List<List<double>> barrierHeight = [
    // out of 2, where 2 is the entire height of the screen
    // [topHeight, bottomHeight]
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  void startGame() {
    gamesHasStarted = true;
    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      // a real physical jump is the same as an upside down parabola
      // this is an quadratic equation
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

      // keep the map moving (move barriers)
      moveMap();

      //keep the time going!
      time += 0.05;
    });
  }

  void moveMap() {
    for (int i = 0; i < barrierX.length; i++) {
      // keep barriers moving
      setState(() {
        barrierX[i] -= 0.05;
      });

      //if barrier exits the left part of the screen, keep it looping
      if (barrierX[i] < -1.5) {
        barrierX[i] += 3;
      }
    }
  }

  void getBestScore(score) {
    if (score > bestScore) {
      bestScore = score;
    }
  }

  void resetGame() {
    Navigator.pop(context); // dismisses the alert dialog
    setState(() {
      getBestScore(score);
      score = 0;
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
            backgroundColor: const Color(0xFFE164B2),
            title: const Center(
                child: Text(
              "G A M E  O V E R",
              style: TextStyle(color: Colors.white),
            )),
            actions: [
              GestureDetector(
                  onTap: resetGame,
                  child: Center(
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
                  ))
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

    // hits barriers
    // checks if bird is within x coordinates and y coordinates of barriers
    for (int i = 0; i < barrierX.length; i++) {
      if (barrierX[i] <= birdWidth &&
          barrierX[i] + barrierWidth >= -birdWidth &&
          (birdY <= -1.047 + barrierHeight[i][0] ||
              birdY + birdHeight >= 1.047 - barrierHeight[i][1])) {
        return true;
      }
    }
    score++;
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
                flex: 3,
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
                          // bird
                          MyBird(
                            birdY: birdY,
                            birdWidth: birdWidth,
                            birdHeight: birdHeight,
                          ),

                          //tap to play
                          //MyCoverScreen(gamesHasStarted : gamesHasStarted)

                          // Top barrier 0
                          MyBarrier(
                            barrierX: barrierX[0],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0][0],
                            isThisBottomBarrier: false,
                          ),

                          // Bottom barrier 0
                          MyBarrier(
                            barrierX: barrierX[0],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[0][1],
                            isThisBottomBarrier: true,
                          ),

                          // Top barrier 1
                          MyBarrier(
                            barrierX: barrierX[1],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1][0],
                            isThisBottomBarrier: false,
                          ),

                          // Bottom barrier 1
                          MyBarrier(
                            barrierX: barrierX[1],
                            barrierWidth: barrierWidth,
                            barrierHeight: barrierHeight[1][1],
                            isThisBottomBarrier: true,
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
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("SCORE",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              const SizedBox(
                                height: 20,
                              ),
                              Text("$score",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 35)),
                            ]),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Text("BEST",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20)),
                              const SizedBox(
                                height: 20,
                              ),
                              Text("$bestScore",
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 35)),
                            ]),
                      ]),
                ),
              ),
            ],
          ),
        ));
  }
}
