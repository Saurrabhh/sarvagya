import 'dart:convert';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:sarvagya/utils/text_to_speech.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import '../../services/api_service.dart';
import '../../utils/dialogs.dart';
import '../../widgets/navigationDrawerWidget.dart';
import '../messages.dart';

class Recommendation extends StatefulWidget {
  const Recommendation({Key? key}) : super(key: key);

  @override
  State<Recommendation> createState() => _RecommendationState();
}

class _RecommendationState extends State<Recommendation> {
  final TextEditingController _controllerBook = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  late SpeechToText speechToText;
  bool _speechEnabled = false;
  String words = "";


  @override
  void initState() {
    _initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recommendation',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        ),

      ),
      body: Column(
        children: [
          Expanded(child: MessagesScreen(messages: messages)),
          Container(
            decoration: BoxDecoration(
                color: Colors.teal.shade800,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _controllerBook,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )),
                IconButton(
                    onPressed: (){
                      sendMessage(_controllerBook.text.trim());
                      _controllerBook.clear();
                    },
                    icon: const Icon(Icons.send)),
                GestureDetector(
                  onTapDown: (details) {
                    _startListening();
                  },
                  onTapUp: (details) {
                    _stopListening();
                  },
                  child: AvatarGlow(
                    animate: _speechEnabled,
                    duration: const Duration(milliseconds: 2000),
                    repeat: true,
                    repeatPauseDuration: const Duration(milliseconds: 100),
                    endRadius: 30.0,
                    child:
                        const CircleAvatar(radius: 25, child: Icon(Icons.mic)),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      drawer: const NavigationDrawerWidget(),
    );
  }

  void _initSpeech() async {
    speechToText = SpeechToText();
    await speechToText.initialize();
  }

  void _startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      _speechEnabled = true;
    });
  }

  void _stopListening() async {
    await speechToText.stop();
    setState(() {
      _speechEnabled = false;
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      words = result.recognizedWords;
      _controllerBook.text = words;
    });
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      debugPrint('No Message found');
      return;
    }
    setState(() {
      addMessage(Message(text: DialogText(text: [text])), true);
    });

    final Map<String, dynamic> responseJson = await ApiService.get("https://demo-bot.skyadav.repl.co/recommend/$text");
    List movieList = responseJson['response'];
    String output = "Here are some movie recommendations:\n-> ${movieList.join("\n-> ")}";
    setState(() {
      addMessage(Message(text: DialogText(text: [output])));
    });
    if (responseJson['response'].toString().contains('BotWheels')) {
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        showBotWheelsDialog(context);
      }
    }
    if (responseJson['response'].toString().contains('Smile Please')) {
      await Future.delayed(const Duration(seconds: 5));
      if (mounted) {
        showSmilePleaseDialog(context);
      }
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }
}
