
import 'package:flutter_tts/flutter_tts.dart';

final FlutterTts flutterTts = FlutterTts();
speak(String text) async{
  await flutterTts.setLanguage("en-US");
  await flutterTts.setPitch(1.5);
  await flutterTts.speak(text);

}