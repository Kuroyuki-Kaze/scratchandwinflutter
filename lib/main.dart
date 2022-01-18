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
  int _wincounter = 0;
  int _scratchcounter = 4;

  void _incrementWins() {
    setState(() {
      _wincounter++;
    });
  }

  void _incrementScratches() {
    setState(() {
      _scratchcounter--;
    });
  }

  final List<int> _scratchBoard = [
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

  final List<int> _mask = [
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
      for (int i = 0; i < 3; i++) {
        _scratchBoard[Random().nextInt(25)] = 1;
      }

      for (int i = 0; i < 25; i++) {
        if (_scratchBoard[i] != 0) {
          _scratchBoard[i] = -1;
        }

        _mask[i] = 0;
      }

      _scratchcounter = 4;
      _wincounter = 0;
    });
  }

  void _handleTap(int index) {
    setState(() {
      int prize = _scratchBoard[index];

      if (prize == 1) {
        _incrementWins();
        _incrementScratches();
      } else if (prize == -1) {
        _incrementScratches();
      }

      _mask[index] = prize;

      if (_scratchcounter == 0) {
        _showAllImages();
        Future.delayed(const Duration(seconds: 5), () {
          _showWinDialog();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _boardInit();

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
                    "Wins: $_wincounter",
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
                      child: _mask[index] == 0
                          ? Image.asset('images/circle.png')
                          : _mask[index] == 1
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
                        MaterialStateProperty.all(Colors.amber[600]),
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
        _mask[i] = _scratchBoard[i];
      }
    });
  }

  void _showWinDialog() {
    int reward = 0;

    switch (reward) {
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
