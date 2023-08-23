import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'helper.dart';
import 'ari.dart';

///Page where various demos are shown.
///It's desinged to specifically showcase 6 options.

Widget buttonCard(String title, String description, Function() onClick) {
  return TextButton(
    style: ButtonStyle(
      padding: MaterialStateProperty.resolveWith(
        (states) {
          return const EdgeInsets.fromLTRB(8, 8, 8, 20);
        },
      ),
    ),
    onPressed: onClick,
    child: Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFBE0),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.topCenter,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Text(
                title,
                style: const TextStyle(fontSize: 36, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              description,
              style: const TextStyle(fontSize: 38, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ),
  );
}

class CapabilitiesPanel extends StatefulWidget {
  const CapabilitiesPanel({super.key});

  @override
  State<StatefulWidget> createState() => _CapabilitiesPanelState();
}

class _CapabilitiesPanelState extends State<StatefulWidget> {
  late Future<Uint8List> _item;

  @override
  void initState() {
    super.initState();
    _item = Ari.camImage();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          const Positioned(
            top: 100,
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
            top: 185,
            left: 215,
            width: 850,
            height: 570,
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFEE80),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: GridView.count(
                padding: const EdgeInsets.symmetric(
                    vertical: (850 / 570) * 8, horizontal: 8),
                crossAxisCount: 3,
                children: [
                  buttonCard("Button1", "TTS", () {
                    Ari.presentation('demo');
                  }),
                  buttonCard("Button2", "Motion", () {}),
                  buttonCard("Button3", "Cam", () {}),
                  buttonCard("Button4", "promo", () {}),
                  buttonCard("Button5", "presentation", () {}),
                  buttonCard("Button6", "another demo", () {}),
                ],
              ),
            ),
          ),
          Helper.positionedBackButton(),
        ],
      ),
    );
  }
}
