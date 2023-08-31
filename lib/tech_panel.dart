import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ari_page/helper.dart';
import 'package:roslibdart/roslibdart.dart';

//Since the resolution of the camera outputs are not queried, I need to manually shift the elements.
const double leftCenter = 110;
const double fontSize = 24;

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

  final Map<String, Topic?> trackedIdTopic = <String, Topic?>{};
  int facesCount = 0;

  List<Text> coordinateLog = [];

  Future<void> subscribeFaceCoordinates(Map<String, dynamic> msg) async {
    Helper.printWrapped(msg.toString());
    msg.remove('do_rectify');
    coordinateLog
        .add(Text(msg.toString(), style: const TextStyle(fontSize: fontSize)));

    if (coordinateLog.length > 5) coordinateLog.removeAt(0);

    setState(() {});
  }

  void detectFaces(Set<String> list) {
    for (var element in list) {
      if (trackedIdTopic[element] == null) {
        final faceCoordsTopic = Topic(
          ros: _ros,
          name: '/humans/faces/$element/roi',
          type: 'sensor_msgs/RegionOfInterest',
          throttleRate: 100,
        );
        faceCoordsTopic.subscribe(subscribeFaceCoordinates);
        trackedIdTopic[element] = faceCoordsTopic;
      }
    }
    List<String> removedStrs = [];
    for (var faceId in trackedIdTopic.keys) {
      if (list.firstWhere((element) => element == faceId, orElse: () => "") ==
          "") {
        trackedIdTopic[faceId]?.unsubscribe();
        removedStrs.add(faceId);
      }
    }

    for (var facesToRemove in removedStrs) {
      trackedIdTopic.remove(facesToRemove);
    }
  }

  Future<void> subscribeFaceDetection(Map<String, dynamic> msg) async {
    facesCount = msg['ids'].length;
    final Set<String> idSet = Set<String>.from(msg['ids']);
    detectFaces(idSet);

    setState(() {});
  }

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
    msg['pose']['orientation']['x'] =
        msg['pose']['orientation']['x'].toStringAsFixed(3);
    msg['pose']['orientation']['y'] =
        msg['pose']['orientation']['y'].toStringAsFixed(3);
    msg['pose']['orientation']['z'] =
        msg['pose']['orientation']['z'].toStringAsFixed(3);
    msg['pose']['orientation']['w'] =
        msg['pose']['orientation']['w'].toStringAsFixed(3);
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

    final faceDetectionTopic = Topic(
        ros: _ros,
        name: '/humans/faces/tracked',
        type: 'hri_msgs/IdsList',
        throttleRate: 100);

    await Topic(
            ros: _ros,
            name: '/dontexist',
            type: 'hri_msgs/IdsList',
            throttleRate: 100)
        .subscribe(subscribeAudioLocation);

    await camTopic.subscribe(subscribeCamOutput);
    await binaryTopic.subscribe(subscribeBinaryCamoutput);
    await thermalTopic.subscribe(subscribeThermalCamoutput);
    await ttsTopic.subscribe(subscribeTTS);
    await faceDetectionTopic.subscribe(subscribeFaceDetection);

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
          left: leftCenter,
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
          left: leftCenter,
          child: Text(
            "Camera outputs (Normal|Binary|Thermal)",
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        const Positioned(
          top: 490,
          left: leftCenter,
          child: Text(
            "Voice Recognition",
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        Positioned(
          top: 510,
          left: leftCenter,
          child: Text(
            speech,
            style: const TextStyle(fontSize: fontSize),
          ),
        ),
        const Positioned(
          top: 530,
          left: leftCenter,
          child: Text(
            'Audio Detection Orientation',
            style: TextStyle(fontSize: fontSize),
          ),
        ),
        Positioned(
          top: 550,
          left: leftCenter,
          child: Text(
            orientationOutput.toString(),
            style: const TextStyle(fontSize: fontSize),
          ),
        ),
        const Positioned(
          top: 470,
          left: leftCenter + 550,
          child: Text(
            "Face Frames Coordinates Log",
            style: TextStyle(fontSize: 24),
          ),
        ),
        Positioned(
          top: 500,
          left: leftCenter + 550,
          child: Column(
            children: coordinateLog,
          ),
        ),
        Helper.positionedBackButton(index: Helper.indexCapabilities),
        Positioned(
          top: 590,
          left: leftCenter,
          child: Text(
            'Number of faces detected: $facesCount',
            style: const TextStyle(fontSize: fontSize),
          ),
        ),
      ],
    );
  }
}
