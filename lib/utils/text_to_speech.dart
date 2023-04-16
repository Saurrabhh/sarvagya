
import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts flutterTts = FlutterTts();
speak(String text) async{
  await flutterTts.setLanguage("en-US");
  await flutterTts.setPitch(1);
  await flutterTts.setSpeechRate(0.4);
  await flutterTts.speak(text);

}