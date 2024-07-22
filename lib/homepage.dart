import 'dart:async';

import 'package:flappy_bird/barriers.dart';
import 'package:flappy_bird/bird.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static double birdYaxis = 0;
  double time = 0;
  double height = 0;
  double initialHeight = birdYaxis;
  bool gameStarted = false;

  int score = 0;
  int highScore = 0;

  static double barrierXone = 2;
  double barrierXtwo = barrierXone + 2;

  void jump() {
    setState(() {
      time = 0;

      initialHeight = birdYaxis;
    });
  }

  void startGame() {
    gameStarted = true;
    birdYaxis = 0;
    time = 0;
    initialHeight = birdYaxis;
    barrierXone = 2;
    barrierXtwo = barrierXone + 2;
    score = 0;

    Timer.periodic(const Duration(milliseconds: 60), (timer) {
      time += 0.04;

      height = -4.9 * time * time + 2.8 * time;

      setState(() {
        birdYaxis = initialHeight - height;

        if (barrierXone < -1.5) {
          barrierXone = 2;
          score += 1;
        } else {
          barrierXone -= 0.05;
        }

        if (barrierXtwo < -2.5) {
          barrierXtwo = 4;
          score += 1;
        } else {
          barrierXtwo -= 0.05;
        }

        // if (barrierXone < -1 || barrierXtwo < -1) {
        //   score += 1;
        // }
      });

      if (birdYaxis > 1 || birdYaxis < -1) {
        if (score > highScore) {
          highScore = score;
        }
        timer.cancel();
        gameStarted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: gameStarted ? jump : startGame,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    AnimatedContainer(
                      alignment: Alignment(0, birdYaxis),
                      duration: const Duration(milliseconds: 0),
                      color: Colors.blue,
                      child: const MyBird(),
                    ),
                    AnimatedContainer(
                        alignment: Alignment(barrierXone, 1.1),
                        duration: const Duration(milliseconds: 0),
                        child: const MyBarrier(size: 200.0)),
                    AnimatedContainer(
                        alignment: Alignment(barrierXone, -1.1),
                        duration: const Duration(milliseconds: 0),
                        child: const MyBarrier(size: 200.0)),
                    AnimatedContainer(
                        alignment: Alignment(barrierXtwo, 1.1),
                        duration: const Duration(milliseconds: 0),
                        child: const MyBarrier(size: 150.0)),
                    AnimatedContainer(
                        alignment: Alignment(barrierXtwo, -1.1),
                        duration: const Duration(milliseconds: 0),
                        child: const MyBarrier(size: 250.0)),
                    Container(
                      alignment: const Alignment(0, -0.3),
                      child: gameStarted
                          ? const Text("")
                          : const Text(
                              "TOCA PARA INICIAR",
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                    ),
                  ],
                )),
            Container(
              height: 15,
              color: Colors.green,
            ),
            Expanded(
                child: Container(
              color: Colors.brown,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Puntos",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('$score',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 35))
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Mejor",
                          style: TextStyle(color: Colors.white, fontSize: 20)),
                      const SizedBox(
                        height: 20,
                      ),
                      Text('$highScore',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 35))
                    ],
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}
