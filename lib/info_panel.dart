import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'helper.dart';

///Page where image and text is displayed

class InformationPanel extends StatefulWidget {
  final String description;
  final String imagePath;
  final String emojiPath;

  const InformationPanel(
      {super.key,
      required this.description,
      required this.imagePath,
      required this.emojiPath});

  @override
  State<StatefulWidget> createState() => _InformationPanelState();
}

class _InformationPanelState extends State<InformationPanel> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Stack(
      fit: StackFit.expand,
      children: [
        //Render Emoji
        Positioned(
          top: 100,
          left: 70,
          child: Image(
            width: 200,
            height: 200,
            image: AssetImage(widget.emojiPath),
          )
              .animate()
              .move(
                begin: const Offset(365, 35),
                curve: Curves.easeOut,
              )
              .scale(
                begin: const Offset(1.2, 1.2),
                curve: Curves.easeOut,
              ),
        ),
        //Render image
        Positioned(
            top: 20,
            left: 750,
            child: Helper.roundedImage(200, widget.imagePath, 400, 400)),
        //Render text
        Positioned(
          top: 500,
          left: 50,
          width: Helper.screenWidth - 100,
          height: 300,
          child: Text(
            widget.description,
            style: Helper.fontBaloo(fontSize: 36),
            textAlign: TextAlign.center,
          ),
        ).animate().fade(duration: const Duration(milliseconds: 1300)).moveY(
            duration: const Duration(milliseconds: 2000),
            begin: 300,
            curve: Curves.easeOutExpo),
        //Render back
        Helper.positionedBackButton(),
      ],
    ));
  }
}
