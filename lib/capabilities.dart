import 'package:flutter/material.dart';
import 'helper.dart';
import 'ari.dart';
import 'dart:convert';

class CapabilitiesPanel extends StatefulWidget {
  const CapabilitiesPanel({super.key});

  @override
  State<StatefulWidget> createState() => _CapabilitiesPanelState();
}

class _CapabilitiesPanelState extends State<StatefulWidget> {
  var item;

  @override
  void initState() {
    super.initState();
    item = Ari.camImage();
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
            top: 200,
            left: 0,
            width: Helper.screenWidth,
            height: 500,
            child: GridView.count(
              crossAxisCount: 6,
              children: [
                TextButton(
                  onPressed: () {
                    Ari.presentation('demo');
                  },
                  child: const Text("Button1"),
                ),
                TextButton(
                  onPressed: () {
                    Ari.motion('shake_left');
                  },
                  child: const Text("Button2"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Button3"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Button4"),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text("Button5"),
                ),
              ],
            ),
          ),
          Helper.positionedBackButton(),
        ],
      ),
    );
  }
}
