import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Scartch and win",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.amber,
          foregroundColor: Colors.black,
        ),
        backgroundColor: Colors.amber[600],
      ),
      home: const ScratchWin(),
    );
  }
}

class ScratchWin extends StatefulWidget {
  const ScratchWin({Key? key}) : super(key: key);

  @override
  _ScratchWinState createState() => _ScratchWinState();
}

class _ScratchWinState extends State<ScratchWin> {
  int wincounter = 0;
  int scratchcounter = 4;

  void _incrementWins() {
    setState(() {
      wincounter++;
    });
  }

  void _incrementScratches() {
    setState(() {
      scratchcounter--;
    });
  }

  List<int> scratchBoard = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];

  List<int> mask = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0
  ];

  void _boardInit() {
    setState(() {
      scratchBoard = [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
      ];

      mask = [
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0,
        0
      ];

      for (int i = 0; i < 3; i++) {
        int randomIndex = Random().nextInt(25);
        while (true) {
          if (scratchBoard[randomIndex] == 1) {
            randomIndex = Random().nextInt(25);
          } else {
            scratchBoard[randomIndex] = 1;
            break;
          }
        }
        scratchBoard[randomIndex] = 1;
      }

      for (int i = 0; i < 25; i++) {
        if (scratchBoard[i] != 1) {
          scratchBoard[i] = -1;
        }

        mask[i] = 0;
      }

      scratchcounter = 4;
      wincounter = 0;
    });
  }

  void _handleTap(int index) {
    int prize = scratchBoard[index];

    setState(() {
      if (prize == 1) {
        _incrementWins();
        _incrementScratches();
      } else if (prize == -1) {
        _incrementScratches();
      }

      mask[index] = prize;
    });

    if (scratchcounter == 0) {
      _showAllImages();
      Future.delayed(const Duration(seconds: 3), () {
        _showWinDialog();
      });
    }
  }

  @override
  void initState() {
    _boardInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scratch and win"),
      ),
      backgroundColor: Colors.amber[600],
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Wins: $wincounter",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: GridView.builder(
              itemCount: 25,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                childAspectRatio: 1.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => _handleTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                    ),
                    child: Center(
                      child: mask[index] == 0
                          ? Image.asset('images/circle.png')
                          : mask[index] == 1
                              ? Image.asset('images/rupee.png')
                              : Image.asset('images/sadFace.png'),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: _showPayouts,
                  child: const Text(
                    "Payouts",
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.amber[800]),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPayouts() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Payouts"),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text(
                    "1x winning symbol: 50 Rs",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "2x winning symbol: 200 Rs",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "3x winning symbol: 1000 Rs",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Close",
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber[600]),
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                ),
              ),
            ],
          );
        });
  }

  void _showAllImages() {
    setState(() {
      for (int i = 0; i < 25; i++) {
        mask[i] = scratchBoard[i];
      }
    });
  }

  void _showWinDialog() {
    int reward = 0;

    switch (wincounter) {
      case 1:
        reward = 50;
        break;
      case 2:
        reward = 200;
        break;
      case 3:
        reward = 1000;
        break;
      default:
        reward = 0;
        break;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "You won $reward Rs",
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _boardInit();
                Navigator.of(context).pop();
              },
              child: const Text(
                "Close",
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.amber[600]),
                foregroundColor: MaterialStateProperty.all(Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
