import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts flutterTts = FlutterTts();
speak(String text) async {
  await flutterTts.setLanguage("en-IN");
  await flutterTts.setPitch(0.56);
  await flutterTts.setSpeechRate(0.56);
  // Future list = flutterTts.getLanguages;
  // list.then((value) {
  //   print(value);
  // });
  await flutterTts.speak(text);
}
