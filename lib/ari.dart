import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

/// Refer to the REST interface page for a general list of http endpoints.
/// http://docs.pal-robotics.com/ari/sdk/23.1/development/js-api.html
///
/// Please note that the link above does not provide all possible endpoints.
/// Refer to the link below for all possible endpoints.
/// http://docs.pal-robotics.com/ari/sdk/23.1/search.html?q=rest&check_keywords=yes&area=default

class Ari {
  /// Play a premade presentation. A presentation is a set of timed actions
  /// that can be created via code or webGUI.
  /// http://docs.pal-robotics.com/ari/sdk/23.1/touchscreen/presentations.html#presentations
  /// http://docs.pal-robotics.com/ari/sdk/23.1/actions/pal_play_presentation_from_name.html
  static void presentation(String id) {
    http.post(
      Uri.parse('http://ari-27c/action/pal_play_presentation_from_name'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'presentation_name': id,
        },
      ),
    );
  }

  /// Get the image displayed by the front-camera.
  /// I'm requesting a new image every 0.5 second to make it look continuous.
  /// This endpoint does not have its own page.
  static Future<Uint8List> camImage() async {
    final response =
        await http.get(Uri.parse('http://ari-27c/topic/head_front_camera'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return base64Decode(json['msg']['data']);
    } else {
      throw Exception("Failed to receive image");
    }
  }

  ///Play a motion. A motion is a key-framed arms & head animation
  ///that can be created via code or webGUI.
  ///http://docs.pal-robotics.com/ari/sdk/23.1/motions/motionbuilder.html#motionbuilder
  ///This endpoint does not have its own page.
  static void motion(String id) {
    http.post(
      Uri.parse('http://ari-27c/action/motion_manager'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'filename': id,
        },
      ),
    );
  }

  ///Reqeust a TTS action. Ari comes only with English by default.
  ///Additional language packs can be requested.
  /// http://docs.pal-robotics.com/ari/sdk/23.1/actions/tts.html
  static void speak(String str) {
    http.post(
      Uri.parse('http://ari-27c/action/tts'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        {
          'rawtext': {
            'text': str,
            'lang_id': 'en_GB',
          },
        },
      ),
    );
  }

  /// Return a string that can be appended to text
  /// to play motion and text-to-speech simultaneously.
  /// This string can be used alone to play motion via tts request.
  static String toAction(String id) {
    return "<mark name='doTrick trickName=$id'/>";
  }
}
