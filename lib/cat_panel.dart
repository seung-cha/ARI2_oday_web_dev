import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'helper.dart';
import 'cat.dart';
import 'ari.dart';
import 'dart:async';
import 'package:video_player_web/video_player_web.dart';
import 'dart:convert';

///This is a debugging page and won't be included later.

class CatPage extends StatefulWidget {
  const CatPage({super.key});

  @override
  State<StatefulWidget> createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  late VideoPlayerController _controller;

  late Future<Cat> _cat;
  late Future<Uint8List> _item;

  late Timer timer;

  @override
  initState() {
    super.initState();
    _cat = Cat.getCat();
    _item = Ari.camImage();

    _controller = VideoPlayerController.networkUrl(Uri.parse(
        "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4"));
    _controller.initialize().then(
      (value) {
        setState(
          () {},
        );
      },
    );

    timer = Timer.periodic(
      const Duration(milliseconds: 500),
      (t) {
        setState(
          () {
            _item = Ari.camImage();
          },
        );
      },
    );
  }

  @override
  void dispose() {
    timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
          FutureBuilder<Uint8List>(
            future: _item,
            builder: (context, data) {
              if (data.hasError || data.data == null) {
                return const Text("Something went wrong");
              }
              return ImageFiltered(
                imageFilter: ImageFilter.blur(),
                child: Image.memory(
                  data.data!,
                  gaplessPlayback: true,
                  scale: 0.5,
                ),
              );
            },
          ),
          FutureBuilder<Cat>(
            future: _cat,
            builder: (context, data) {
              if (data.hasData || data.hasError) {
                return Stack(
                  children: [
                    Positioned(
                      top: Helper.screenHeight / 2 + 200,
                      left: 370,
                      width: 500,
                      child: Text(
                        data.hasError ? "Woops, something went wrong." : "",
                        style:
                            const TextStyle(fontSize: 34, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Positioned(
                      top: Helper.screenHeight / 2 - 300,
                      left: Helper.screenWidth / 2 - 250,
                      child: Image.network(
                        data.hasError
                            ? 'https://httpcats.com/409.jpg'
                            : data.data!.url,
                        errorBuilder: (context, obj, e) => const Text(
                          '¯\\_(ツ)_/¯',
                          style: TextStyle(fontSize: 128, fontFamily: ""),
                          textAlign: TextAlign.center,
                        ),
                        alignment: Alignment.bottomCenter,
                        width: 500,
                        height: 500,
                      ),
                    ),
                  ],
                );
              }

              return const Positioned(
                  top: Helper.screenHeight / 2,
                  left: Helper.screenWidth / 2,
                  child: CircularProgressIndicator());
            },
          ),
          Positioned(
            top: 300,
            left: 150,
            child: Text(
                "${MediaQuery.of(context).size.width}x${MediaQuery.of(context).size.height}"),
          ),
          Positioned(
            top: 0,
            left: 700,
            width: 300,
            height: 300,
            child: VideoPlayer(_controller),
          ),
          Helper.positionedBackButton(),
        ],
      ),
    );
  }
}
