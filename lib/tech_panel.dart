import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ari_page/helper.dart';
import 'package:roslibdart/roslibdart.dart';

class TechPanel extends StatefulWidget {
  const TechPanel({super.key});

  @override
  State<StatefulWidget> createState() => _TechPanelState();
}

class _TechPanelState extends State<TechPanel> {
  late Ros _ros;

  late Uint8List camOutput;
  late Uint8List binaryCamOutput;
  late Uint8List thermalCamOutput;
  late dynamic orientationOutput;

  String speech = "";

  int camOutputMode = 0;

  Future<void> subscribeCamOutput(Map<String, dynamic> msg) async {
    camOutput = base64Decode(msg['data']);
    setState(() {});
  }

  Future<void> subscribeBinaryCamoutput(Map<String, dynamic> msg) async {
    binaryCamOutput = base64Decode(msg['data']);
    setState(() {});
  }

  Future<void> subscribeThermalCamoutput(Map<String, dynamic> msg) async {
    thermalCamOutput = base64Decode(msg['data']);
    setState(() {});
  }

  Future<void> subscribeTTS(Map<String, dynamic> msg) async {
    speech = msg['incremental'];
    setState(() {});
  }

  Future<void> debugPrint(Map<String, dynamic> msg) async {
    Helper.printWrapped(msg['pose']['orientation'].toString());
  }

  Future<void> subscribeAudioLocation(Map<String, dynamic> msg) async {
    orientationOutput = msg['pose']['orientation'];
  }

  Future<void> init() async {
    _ros = Ros(url: 'ws://ari-27c:9090');
    _ros.connect();

    orientationOutput = List.empty();

    final camTopic = Topic(
      ros: _ros,
      name: '/head_front_camera/color/image_raw/compressed',
      type: 'sensor_msgs/CompressedImage',
      throttleRate: 100,
    );

    //await camTopic.subscribe();

    final binaryTopic = Topic(
      ros: _ros,
      name: '/teraranger_evo_thermal/template_detection/binary/compressed',
      type: 'sensor_msgs/CompressedImage',
      throttleRate: 100,
    );

    final thermalTopic = Topic(
      ros: _ros,
      name: '/teraranger_evo_thermal/template_detection/colormap/compressed',
      type: 'sensor_msgs/CompressedImage',
      throttleRate: 100,
    );

    final ttsTopic = Topic(
        ros: _ros,
        name: '/humans/voices/anonymous_speaker/speech',
        type: 'hri_msgs/LiveSpeech',
        throttleRate: 100);

    final audioLocalTopic = Topic(
        ros: _ros,
        name: '/audio/sound_localization',
        type: 'geometry_msgs/PoseStamped',
        throttleRate: 100);

    await camTopic.subscribe(subscribeCamOutput);
    await binaryTopic.subscribe(subscribeBinaryCamoutput);
    await thermalTopic.subscribe(subscribeThermalCamoutput);
    await ttsTopic.subscribe(subscribeTTS);

    await audioLocalTopic.subscribe(subscribeAudioLocation);
  }

  @override
  void initState() {
    super.initState();
    camOutput = Uint8List.fromList([0]);
    binaryCamOutput = Uint8List.fromList([0]);
    thermalCamOutput = Uint8List.fromList([0]);
    init();
  }

  @override
  void dispose() {
    _ros.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 150,
          left: 0,
          child: Row(
            children: [
              Image.memory(
                camOutput,
                gaplessPlayback: true,
                scale: 1.5,
              ),
              Image.memory(
                binaryCamOutput,
                gaplessPlayback: true,
                scale: 0.1,
              ),
              Image.memory(
                thermalCamOutput,
                gaplessPlayback: true,
                scale: 0.1,
              ),
            ],
          ),
        ),
        const Positioned(
          top: 470,
          left: 0,
          child: Text(
            "Camera outputs (Normal|Binary|Thermal)",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const Positioned(
          top: 490,
          left: 0,
          child: Text(
            "Voice Recognition",
            style: TextStyle(fontSize: 16),
          ),
        ),
        Positioned(
          top: 510,
          left: 0,
          child: Text(
            speech,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const Positioned(
          top: 530,
          left: 0,
          child: Text(
            'Audio Detection Orientation',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Positioned(
          top: 550,
          left: 0,
          child: Text(
            orientationOutput.toString(),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Helper.positionedBackButton(index: Helper.indexCapabilities),
      ],
    );
  }
}
