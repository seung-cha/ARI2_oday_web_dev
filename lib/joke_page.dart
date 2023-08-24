import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'helper.dart';
import 'dart:async';

class JokePage extends StatefulWidget {
  const JokePage({super.key});

  @override
  State<StatefulWidget> createState() => _JokePageState();
}

class _JokePageState extends State<JokePage> {
  late String line;
  int state = 0;

  @override
  void initState() {
    super.initState();
    line = Helper.joke.line1;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        line,
        style: const TextStyle(fontSize: 28),
      )
          .animate(
            delay: Duration(milliseconds: 4000),
            onPlay: (controller) {
              setState(
                () {
                  line = Helper.joke.line2;
                },
              );
            },
            onComplete: (controller) {
              Helper.pageIndex.value = Helper.indexCapabilities;
            },
          )
          .then(
            delay: Duration(milliseconds: 4000),
          ),
    );
  }
}
