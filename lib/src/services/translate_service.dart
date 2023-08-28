import 'dart:convert';

import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart' as http;

class TranslateService {
  TranslateService();
  final String apiKey = 'AIzaSyC2pffsGDXLgsLunQSWrnm6MGvVoAf6h3o';
  final String _rootUrl =
      "https://translation.googleapis.com/language/translate/v2";

  Future<String> translate(String text, String idioma) async {
    try {
      var uri = Uri.parse('$_rootUrl?q=$text&target=$idioma&key=$apiKey');
      var response = await http.post(uri);

      if (response.statusCode == 400) {
        return "Lo Sentimos. \n No se puedo traducir. \n Revise su conexión a internet";
      }

      final body = json.decode(response.body);
      final translations = body['data']['translations'];
      final translation =
          HtmlUnescape().convert(translations.first['translatedText']);
      return translation;
    } catch (ex) {
      return " Lo Sentimos. \n No se pudo traducir \n Revise su conexión a internet";
    }
  }
}
