import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class Cat {
  final String url;
  final int width;
  final int height;

  const Cat({required this.url, required this.width, required this.height});

  static Future<Cat> getCat() async {
    final request =
        await http.get(Uri.parse('https://api.thecatapi.com/v1/images/search'));

    if (request.statusCode == 200) {
      final json = jsonDecode(request.body);
      final data = json[0];
      return Cat.jsonPrase(data);
    } else {
      developer.log("Cat request was not successful!\n");
      throw Exception('Failed to load a cat image!');
    }
  }

  factory Cat.jsonPrase(Map<String, dynamic> json) {
    return Cat(url: json['url'], width: json['width'], height: json['height']);
  }
}
