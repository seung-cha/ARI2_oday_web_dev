import 'package:flutter/material.dart';
import 'ari.dart';
import 'joke.dart';

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
  static const int indexJokePage = 7;
  static const int indexTechPage = 8;

  static late Joke joke;
  static late int jokeDuration1;
  static late int jokeDuration2;

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

  static Widget itemBuilder(
      int id, String imagePath, String title, String description, int toIndex,
      {double width = 540, double height = 720}) {
    return TextButton(
      style: ButtonStyle(
        splashFactory: NoSplash.splashFactory,
        overlayColor: MaterialStateProperty.all(Colors.transparent),
      ),
      onPressed: () =>
          {if (Helper.focusedItem == id) Helper.pageIndex.value = toIndex},
      child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: [
              Align(
                alignment: const Alignment(0, -0.6),
                child: Image(
                  image: AssetImage(imagePath),
                  width: 250,
                  height: 250,
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.2),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 64, color: Colors.black),
                ),
              ),
              Align(
                alignment: const Alignment(0, 0.6),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 48, color: Colors.black),
                ),
              ),
            ],
          )),
    );
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

  ///To be deleted
  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  //------------ Emoji -----------------------------
  static const smileEmojiPath = 'images/Smile.png';
  static const medalEmojiPath = 'images/Medal.png';
  static const tempEmojiPath = 'images/Temp.png';
  static const lightBulbEmojiPath = 'images/lightbulb.png';
  static const pencilEmojiPath = 'images/pencil.png';
  static const wifiEmojiPath = 'images/wifi.png';
  static const speechBubbleEmojiPath = 'images/Speechbubble.png';
  static const playEmojiPath = 'images/Playcircle.png';
  static const cameraEmojiPath = 'images/Camera.png';
  static const qrCodePath = 'images/qrcode.jpg';
  //------------------------------------------------
  //------------ Image -----------------------------
  static const ariImagePath = 'images/ari_face.jpg';
  static const odayImagePath = 'images/unsw_person.png';
  //------------------------------------------------
  //------------ Str -------------------------------

  ///Each text contains two strings; one for display and the other for tts.
  static const ariIntroductionStr = "Hi! I'm Ari."
      " I am a social humanoid robot currently serving as an assistant robot."
      " If you want to know more about what I can do, check out the \"Interaction\" section!";

  static final ariIntroductionSpeech = "${Ari.toAction('wave')}Hi! I'm Ari."
      " I am a social humanoid robot currently serving as an assistant robot."
      " ${Ari.toAction('nod')}If you want to know more about what I can do, check out the interaction section!";

  static const odayStr =
      "Step into a world of possibilities at UNSW's Open Day!"
      " From exploring innovative programs to connecting with passionate faculty members, "
      "this event is your gateway to discovering the exciting academic journey that awaits you.";
  static final odaySpeech =
      "${Ari.toAction('look_around')}Step into a world of possibilities at U-N-S-W's Open Day!"
      " From exploring innovative programs to connecting with passionate faculty members, "
      "this event is your gateway to discovering${Ari.toAction('show_left')} the exciting academic journey that awaits you.";

  static const feedbackStr = "Thank you for your interest in the robot!"
      " This robot is currently being developed as my research project."
      " Scan the QR code and leave me a feedback! your feedback is greatly appreciated!";

  static final feedbackSpeech =
      "${Ari.toAction('bow')}Thank you for your interest in the robot!"
      " This robot is currently being developed as my research project."
      " Scan the QR code and leave me a feedback! your feedback is greatly appreciated!";

  static const capabilitiesSpeech = "What do you want me to show you?";
}
