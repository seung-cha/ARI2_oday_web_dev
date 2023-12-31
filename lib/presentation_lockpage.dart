import 'package:flutter/material.dart';
import 'helper.dart';

class PresentationLockScreen extends StatelessWidget {
  PresentationLockScreen({super.key}) {
    Future.delayed(const Duration(seconds: 21))
        .then((value) => Helper.pageIndex.value = Helper.indexCapabilities);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Hey, look at me go! :D",
        style: Helper.fontBaloo(fontSize: 52),
      ),
    );
  }
}
