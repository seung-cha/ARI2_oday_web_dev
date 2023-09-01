import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'helper.dart';
import 'ari.dart';

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
    Ari.speak(line);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        line,
        style: Helper.fontBaloo(fontSize: 36),
      )
          .animate(
            delay: Duration(seconds: Helper.jokeDuration1 + 2),
            onPlay: (controller) {
              setState(
                () {
                  line = Helper.joke.line2;
                  Ari.speak(line);
                },
              );
            },
            onComplete: (controller) {
              Helper.pageIndex.value = Helper.indexCapabilities;
            },
          )
          .then(
            delay: Duration(seconds: Helper.jokeDuration2 + 2),
          ),
    );
  }
}
