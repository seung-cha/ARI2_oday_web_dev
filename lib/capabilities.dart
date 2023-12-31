import 'package:flutter/material.dart';
import 'helper.dart';
import 'ari.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'joke.dart';
import 'dart:math';

Widget itemBuilder(
    String imagePath, String title, String description, Function onPressed,
    {double width = 350, double height = 540}) {
  return TextButton(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    ),
    onPressed: () {
      onPressed.call();
    },
    child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Align(
              alignment: const Alignment(0, -0.8),
              child: Image(
                image: AssetImage(imagePath),
                width: 150,
                height: 150,
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.1),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 48, color: Colors.black),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.5),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: Helper.fontBaloo(fontSize: 32, color: Colors.black),
              ),
            ),
          ],
        )),
  );
}

class CapabilitiesPanel extends StatefulWidget {
  const CapabilitiesPanel({super.key});

  @override
  State<StatefulWidget> createState() => _CapabilitiesPanelState();
}

class _CapabilitiesPanelState extends State<StatefulWidget> {
  var jokeRequested = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(
          top: 80,
          left: 0,
          width: Helper.screenWidth,
          height: 100,
          child: Text(
            "What do you want me to show you?",
            style: TextStyle(fontSize: 48),
            textAlign: TextAlign.center,
          ),
        ),
        Positioned(
          top: 170,
          left: 90,
          child: itemBuilder(
            Helper.speechBubbleEmojiPath,
            "JOKE",
            "I will tell you an uncle joke. I will be funny ;D",
            () {
              if (jokeRequested) return;

              jokeRequested = true;
              Ari.speak("Okay, let me think of one.");
              // Delay the execution of script by 1 second.
              Joke.getJoke(programmingJoke: Random().nextInt(10) + 1 > 7).then(
                (value) => {
                  Helper.joke = value,
                  Ari.speechDuration(Helper.joke.line1).then(
                    (value_) => {
                      Helper.jokeDuration1 = value_ == -1 ? 5 : value_,
                      Ari.speechDuration(Helper.joke.line2).then(
                        (value_) => {
                          Helper.jokeDuration2 = value_ == -1 ? 3 : value_,
                          Future.delayed(const Duration(milliseconds: 500))
                              .then((value) =>
                                  Helper.pageIndex.value = Helper.indexJokePage)
                        },
                      ),
                    },
                  ),
                },
                onError: (obj) {
                  Future.delayed(const Duration(milliseconds: 2000)).then(
                    (value) {
                      const str =
                          "Sorry, I can't think of one right now. Please ask me later.";
                      Ari.speak(str);
                      jokeRequested = false;
                    },
                  );
                },
              );
            },
          ),
        ).animate().fade(duration: const Duration(milliseconds: 600)).moveY(
            duration: const Duration(milliseconds: 1000),
            begin: 300,
            curve: Curves.easeOutExpo),
        Positioned(
          top: 170,
          left: 465,
          child: itemBuilder(
            Helper.playEmojiPath,
            "PRESENTATION",
            "I will show you what I can do!",
            () {
              Ari.presentation('demo');
              Helper.pageIndex.value = Helper.indexPresentationLock;
            },
          ),
        )
            .animate()
            .fade(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 100))
            .moveY(
                duration: const Duration(milliseconds: 1000),
                begin: 300,
                curve: Curves.easeOutExpo),
        Positioned(
          top: 170,
          left: 840,
          child: itemBuilder(
            Helper.cameraEmojiPath,
            "STATS FOR NERDS",
            "Other data from me",
            () {
              Helper.pageIndex.value = Helper.indexTechPage;
            },
          ),
        )
            .animate()
            .fade(
                duration: const Duration(milliseconds: 600),
                delay: const Duration(milliseconds: 200))
            .moveY(
                duration: const Duration(milliseconds: 1000),
                begin: 300,
                curve: Curves.easeOutExpo),
        Align(
          alignment: const Alignment(0.9, 0.95),
          child: Text(
            "Post my pictures on social media! #unswari",
            style: Helper.fontBaloo(fontSize: 26),
          ),
        ),
        Helper.positionedBackButton(),
      ],
    );
  }
}
