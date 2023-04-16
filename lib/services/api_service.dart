import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService{
  static Future<Map<String, dynamic>> get(
      String url, {Map<String, dynamic>? params}) async {
    Uri uri = Uri.parse(url);
    uri = uri.replace(queryParameters: params);

    print("Api Get Call : $uri");
    final response = await http.get(uri);
    print("Hello");
    String responseBody = utf8.decoder.convert(response.bodyBytes);
    final Map<String, dynamic> responseJson = json.decode(responseBody);
    print("Response : $responseJson");
    return responseJson;
  }
}