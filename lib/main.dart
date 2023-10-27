import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _ClockTimer(title: 'Clock Timer'),
    );
  }
}

class _ClockTimer extends StatefulWidget {
  const _ClockTimer({super.key, required this.title});

  final String title;

  @override
  State<_ClockTimer> createState() => _CountdownTimerDemoState();
}

class _CountdownTimerDemoState extends State<_ClockTimer> {
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 20);
  final myController = TextEditingController();
  var i = 0;
  var life = 4;

  List<String> answers = ['nose', 'eyes', 'ear', 'mouth'];
  List<String> hints = [
    'Hint: A part of your body that allows air to enter your body',
    'Hint: A part of your body that allows you to see',
    "Hint: A part of your body that allows you to hear",
    "Hint: A part of your body that allows you to talk"
  ];

  void setLife(n) {
    life = n;
  }

  void setI(n) {
    i = n;
  }

  @override
  void initState() {
    super.initState();
  }

  void startTimer() {
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void stopTimer() {
    setState(() => countdownTimer!.cancel());
  }

  void resetTimer() {
    stopTimer();
    setState(() => myDuration = const Duration(seconds: 20));
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    setState(() {
      final seconds = myDuration.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        myDuration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // if (life == 0 || myDuration.inSeconds.remainder(60) == 0) {
    //   showDialog(
    //     context: context,
    //     builder: (context) {
    //       return const AlertDialog(
    //         content: Text("Game Over"),
    //       );
    //     },
    //   );
    // }
    String strDigits(int n) => n.toString().padLeft(2, '0');
    final days = strDigits(myDuration.inSeconds);
    final seconds = strDigits(myDuration.inSeconds.remainder(60));

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Text(
              '$seconds',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 100),
            ),
            Text(hints[i].toString()),
            Container(
              height: 25,
              width: 300,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 112, 124, 232)),
              child: TextField(
                decoration: const InputDecoration(
                    hintText: "Input your Answer Here",
                    border: InputBorder.none),
                controller: myController,
              ),
            ),
            TextButton(
              // When the user presses the button, show an alert dialog containing
              // the text that the user has entered into the text field.
              onPressed: () {
                if (life == 0) {
                  if (myController.text.toString() == answers[i]) {
                    resetTimer();
                    startTimer();
                    myController.text = "";
                    if (i >= answers.length - 1) {
                      setI(0);
                    } else {
                      setI(i + 1);
                    }
                  } else if (myController.text != answers[i]) {
                    setLife(life - 1);
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          content: Text("Wrong Answer"),
                        );
                      },
                    );
                  }
                } else {
                  stopTimer();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text("Game Over"),
                      );
                    },
                  );
                }
              },
              child: const Text("Submit Answer"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 0),
              child: Row(
                children: [
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: startTimer,
                    child: const Text(
                      'Start',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (countdownTimer == null || countdownTimer!.isActive) {
                        stopTimer();
                      }
                    },
                    child: const Text(
                      'Pause',
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                  ),
                  // Step 11
                  ElevatedButton(
                      onPressed: () {
                        resetTimer();
                      },
                      child: const Text(
                        'Reset',
                        style: TextStyle(
                          fontSize: 30,
                        ),
                      )),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text("Number of Life"),
            ),
            SizedBox(
              height: 100,
              width: 350,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: life,
                itemBuilder: (context, index) {
                  return const Icon(Icons.favorite);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Container(
                width: 550,
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.lightBlue),
                child: const Center(
                  child: Text(
                      "Instructions: This game is called Question and Answer with a timer and a hint\nYou've got 4 lives, The heart represents your life,\n every wrong decreases your life, if time is equals to zero it's game over\nInput the Correct Answer,if you got the answer the time will reset."),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
