import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'helper.dart';
import 'cat.dart';
import 'ari.dart';
import 'dart:async';
import 'package:roslibdart/roslibdart.dart';
import 'dart:convert';

///This is a debugging page and won't be included later.

class CatPage extends StatefulWidget {
  const CatPage({super.key});

  @override
  State<StatefulWidget> createState() => _CatPageState();
}

class _CatPageState extends State<CatPage> {
  late Future<Cat> _cat;
  late Future<Uint8List> _item;
  late Ros _ros;

  String camOutput = "";

  Future<void> subHandler(Map<String, dynamic> msg) async {
    camOutput = msg['data'];
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    _cat = Cat.getCat();
    _item = Ari.camImage();

    _ros = Ros(url: 'ws://ari-27c:9090');
    final chatter = Topic(
      ros: _ros,
      name: '/head_front_camera/color/image_raw/compressed',
      type: 'sensor_msgs/CompressedImage',
      throttleRate: 100,
    );

    _ros.connect();
    chatter.subscribe(subHandler);
  }

  @override
  void dispose() {
    _ros.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Stack(
        children: [
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
          Align(
            alignment: const Alignment(0.6, -0.5),
            child: Image.memory(
              base64Decode(camOutput),
              gaplessPlayback: true,
            ),
          ),
          Helper.positionedBackButton(),
        ],
      ),
    );
  }
}
