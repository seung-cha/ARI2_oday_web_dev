import 'dart:convert';
import 'package:http/http.dart' as http;

class Joke {
  final String line1;
  final String line2;

  const Joke({required this.line1, required this.line2});

  static Future<Joke> getJoke({bool programmingJoke = false}) async {
    final request = await http.get(Uri.parse(!programmingJoke
        ? 'https://v2.jokeapi.dev/joke/Pun?blacklistFlags=nsfw,religious,political,racist,sexist,explicit&type=twopart'
        : 'https://v2.jokeapi.dev/joke/Programming?blacklistFlags=nsfw,religious,political,racist,sexist,explicit&type=twopart'));

    if (request.statusCode == 200) {
      final json = jsonDecode(request.body);
      final data = json;
      return Joke.jsonPrase(data);
    } else {
      throw Exception('Failed to load a joke!');
    }
  }

  factory Joke.jsonPrase(Map<String, dynamic> json) {
    return Joke(line1: json['setup'], line2: json['delivery']);
  }
}
