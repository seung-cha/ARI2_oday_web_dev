import 'package:flutter/material.dart';
import 'ari.dart';

///This class contains various constants and helper functions.

class Helper {
  //Lazy implementation of state-machine design pattern (hehe)
  static const int indexLockScreen = 0;
  static const int indexMainMenu = 1;
  static const int indexAriIntroPage = 2;
  static const int indexOdayPage = 3;
  static const int indexCapabilities = 4;
  static const int indexfeedbackPage = 5;
  static const int indexCatPage = 6;

  static ValueNotifier<int> pageIndex = ValueNotifier(indexLockScreen);

  /// Although the touch screen is 1200x800,
  /// web resolution is 1280x800.
  static const double screenWidth = 1280.0;
  static const double screenHeight = 800.0;

  //How long does it take to go back to the lock screen
  static const int idleDuration = 45;

  //Highlighted item
  static int focusedItem = 2;

  //Background
  static const unswBackgroundDecoration = BoxDecoration(
    image: DecorationImage(
      image: AssetImage('images/background.png'),
      fit: BoxFit.cover,
    ),
  );

  //Back button
  static Widget positionedBackButton(
      {double top = 710, double left = 0, int index = indexMainMenu}) {
    return Positioned(
        top: top,
        left: left,
        width: 200,
        height: 100,
        child: TextButton(
          onPressed: () => pageIndex.value = index,
          child: const Text("Back",
              style: TextStyle(fontSize: 40, color: Colors.black)),
        ));
  }

  //bordered image
  static Widget roundedImage(
      double radius, String path, double width, double height) {
    return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(path), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(radius)));
  }

  //------------ Emoji -----------------------------
  static const smileEmojiPath = 'images/Smile.png';
  static const medalEmojiPath = 'images/Medal.png';
  static const tempEmojiPath = 'images/Temp.png';
  static const lightBulbEmojiPath = 'images/lightbulb.png';
  static const pencilEmojiPath = 'images/pencil.png';
  static const wifiEmojiPath = 'images/wifi.png';
  //------------------------------------------------
  //------------ Image -----------------------------
  static const ariImagePath = 'images/ari_face.jpg';
  static const odayImagePath = 'images/unsw_person.png';
  //------------------------------------------------
  //------------ Str -------------------------------

  ///Each text contains two strings; one for display and the other for tts.
  static const ariIntroductionStr = "Welcome to the Open Day! I'm Ari."
      " I am a multi-modal humanoid robot currently serving as an assistant robot."
      " If you want to know more about my capabilities, check out the \"MY CAPABILITIES\" section!";

  static final ariIntroductionSpeech =
      "${Ari.toAction('wave')}Welcome to the Open Day! I'm Ari."
      " I am a multi-modal humanoid robot currently serving as an assistant robot."
      " ${Ari.toAction('nod')}If you want to know more about my capabilities, check out the \"MY CAPABILITIES\" section!";

  static const odayStr = "odayString to Here";
  static final odaySpeech = "oday speech go here";

  static const feedbackStr = "Thank you for your interest in the robot!"
      " This robot is currently being developed as my research project."
      " Scan the QR code and leave me a feedback! your feedback is greatly appreciated!";

  static final feedbackSpeech =
      "${Ari.toAction('bow')}Thank you for your interest in the robot!"
      " This robot is currently being developed as my research project."
      " Scan the QR code and leave me a feedback! your feedback is greatly appreciated!";

  static final capabilitiesSpeech = "What do you want me to show you?";
}
