import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'helper.dart';
import 'dart:async';
import 'ari.dart';

const double itemWidth = 540;
const double itemHeight = 720;

Widget itemBuilder(
    int id, String imagePath, String title, String description, int toIndex) {
  return TextButton(
    style: ButtonStyle(
      splashFactory: NoSplash.splashFactory,
      overlayColor: MaterialStateProperty.all(Colors.transparent),
    ),
    onPressed: () =>
        {if (Helper.focusedItem == id) Helper.pageIndex.value = toIndex},
    child: SizedBox(
        width: itemWidth,
        height: itemHeight,
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

class MainScreenContainer extends StatefulWidget {
  const MainScreenContainer({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenContainerState();
}

class _MainScreenContainerState extends State<MainScreenContainer> {
  late Timer timer;
  List<Widget> selectables = [];

  @override
  void initState() {
    super.initState();
    timer = Timer(const Duration(seconds: Helper.idleDuration), () {
      Helper.pageIndex.value = Helper.indexLockScreen;
    });

    //Make ARI say something
    Ari.speak("Please touch the screen to begin.");

    //Add items, in order

    //My capabilities
    selectables.add(SizedBox(
      child: itemBuilder(
          selectables.length,
          Helper.lightBulbEmojiPath,
          'MY CAPABILITIES',
          'Want To See What I Can Do?',
          Helper.indexCapabilities),
    ));

    //About Me
    selectables.add(SizedBox(
      child: itemBuilder(selectables.length, Helper.smileEmojiPath, 'ABOUT ME',
          'Curious About Me? Check Me Out!', Helper.indexAriIntroPage),
    ));

    //Why UNSW
    selectables.add(SizedBox(
      child: itemBuilder(selectables.length, Helper.medalEmojiPath, 'WHY UNSW',
          'Discover What Makes UNSW Ideal For You', Helper.indexOdayPage),
    ));

    //Feedback
    selectables.add(SizedBox(
      child: itemBuilder(
          selectables.length,
          Helper.pencilEmojiPath,
          'Feedback',
          'Do You Like The Robot? Leave Me a Feedback!',
          Helper.indexfeedbackPage),
    ));

    //Cat
    selectables.add(SizedBox(
      child: itemBuilder(selectables.length, Helper.wifiEmojiPath, 'Cat',
          'Meow.', Helper.indexCatPage),
    ));

    //Temp
    selectables.add(SizedBox(
      child: itemBuilder(selectables.length, Helper.tempEmojiPath, 'TEMP',
          'Temporary Button Reserved for Later Use', Helper.indexLockScreen),
    ));
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ScrollSnapList(
        initialIndex: Helper.focusedItem.toDouble(),
        duration: 300,
        dynamicItemSize: true,
        dynamicItemOpacity: 0.25,
        itemBuilder: (build, i) => selectables[i],
        itemCount: selectables.length,
        itemSize: itemWidth,
        onItemFocus: (i) => Helper.focusedItem = i,
      )
          .animate()
          .moveY(
              begin: -100,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutQuad)
          .fade(duration: const Duration(milliseconds: 1500)),
    );
  }
}
