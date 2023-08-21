import 'package:flutter/material.dart';
import 'helper.dart';

class LockScreenContainer extends StatefulWidget {
  const LockScreenContainer({super.key});

  @override
  State<StatefulWidget> createState() => _LockScreenContainerState();
}

class _LockScreenContainerState extends State<LockScreenContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _blinkingTextController;

  @override
  void initState() {
    super.initState();
    _blinkingTextController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
        milliseconds: 500,
      ),
    )..repeat(reverse: true);

    Helper.focusedItem = 2;
  }

  @override
  void dispose() {
    _blinkingTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextButton(
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        onPressed: () => {Helper.pageIndex.value = Helper.indexMainMenu},
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              top: 150,
              right: 0,
              width: 1280,
              height: 200,
              child: Text(
                'Discover Your Next Step',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 96),
              ),
            ),
            const Positioned(
              top: 360,
              right: 0,
              width: 1280,
              height: 200,
              child: Text(
                'UNSW OPEN DAY',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 96),
              ),
            ),
            Positioned(
              top: 650,
              right: 0,
              width: 1280,
              height: 100,
              child: FadeTransition(
                opacity: _blinkingTextController,
                child: const Text(
                  'TOUCH TO BEGIN',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 40),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
