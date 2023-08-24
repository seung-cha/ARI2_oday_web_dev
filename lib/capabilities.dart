import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'helper.dart';
import 'ari.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'joke.dart';
import 'joke_page.dart';
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
                style: const TextStyle(fontSize: 56, color: Colors.black),
              ),
            ),
            Align(
              alignment: const Alignment(0, 0.5),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 32, color: Colors.black),
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
            "Joke",
            "I will tell you an uncle joke. I will be funny ;D",
            () {
              Joke.getJoke(programmingJoke: Random().nextInt(10) + 1 > 7).then(
                (value) => {
                  Helper.joke = value,
                  Helper.pageIndex.value = Helper.indexJokePage
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
            "Presentation",
            "I will show you what I can do!",
            () {},
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
            "Camera",
            "Temporary",
            () {},
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
        Helper.positionedBackButton(),
      ],
    );
  }
}
