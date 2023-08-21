import 'package:flutter/material.dart';
import 'lock_container.dart';
import 'main_container.dart';
import 'helper.dart';
import 'dart:ui';
import 'info_panel.dart';
import 'cat_panel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'ari.dart';
import 'capabilities.dart';

class Master extends StatelessWidget {
  const Master({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(textTheme: GoogleFonts.bakbakOneTextTheme()),
        scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch}),
        home: const MasterPage());
  }
}

class MasterPage extends StatefulWidget {
  const MasterPage({super.key});

  @override
  State<StatefulWidget> createState() => _MasterPageState();
}

class _MasterPageState extends State<MasterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: Helper.screenWidth,
        height: Helper.screenHeight,
        decoration: Helper.unswBackgroundDecoration,
        child: ValueListenableBuilder<int>(
            valueListenable: Helper.pageIndex,
            builder: (context, value, _) {
              //Lazy implementation of finite state machine.
              switch (value) {
                //Lock screen
                case Helper.indexLockScreen:
                  return const LockScreenContainer();
                //Menu
                case Helper.indexMainMenu:
                  return const MainScreenContainer();
                //Ari intro
                case Helper.indexAriIntroPage:
                  Ari.speak(Helper.ariIntroductionSpeech);
                  return const InformationPanel(
                      description: Helper.ariIntroductionStr,
                      imagePath: Helper.ariImagePath,
                      emojiPath: Helper.smileEmojiPath);
                //Oday page
                case Helper.indexOdayPage:
                  Ari.speak(Helper.odaySpeech);
                  return const InformationPanel(
                    description: Helper.odayStr,
                    imagePath: Helper.odayImagePath,
                    emojiPath: Helper.medalEmojiPath,
                  );
                //Feedback
                case Helper.indexfeedbackPage:
                  Ari.speak(Helper.feedbackSpeech);
                  return const InformationPanel(
                    description: Helper.feedbackStr,
                    imagePath: Helper.pencilEmojiPath,
                    emojiPath: Helper.pencilEmojiPath,
                  );
                //Cat
                case Helper.indexCatPage:
                  return const CatPage();
                //Showcase
                case Helper.indexCapabilities:
                  Ari.speak(Helper.capabilitiesSpeech);
                  return const CapabilitiesPanel();
                default:
                  return const LockScreenContainer();
              }
            }),
      ),
    );
  }
}
