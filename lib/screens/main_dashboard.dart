import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:http/http.dart' as http;
import '../dataclass/person.dart';
import '../utils/dialogs.dart';
import '../utils/text_to_speech.dart';
import '../widgets/navigationDrawerWidget.dart';
import 'messages.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});
  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  late SpeechToText speechToText;
  bool _speechEnabled = false;
  bool notInit = true;
  String words = "";
  List<String> modes = ['Hi', 'What is your name ?', 'Drive Mode' , 'Recommend me a book' , 'Help'];
  late Person person;
  late Future future = initPerson();

  initPerson() async {
    final snapshot = await FirebaseDatabase.instance.ref("Users/${FirebaseAuth.instance.currentUser!.uid}").get();
    person = Person.fromJson(snapshot.value as Map);
    return person;
  }

  sayHello() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      addMessage(Message(text: DialogText(text: ["Hello ${person.name}"])));
      speak("Hello ${person.name}");
    });
  }
  @override
  void initState() {
    person = Provider.of<Person>(context, listen: false);
    _initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sarvagya',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, 'login', (route) => false);
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: future,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting){
                return const Expanded(child: Center(child: CircularProgressIndicator()));
              }
              if(notInit){
                notInit = false;
                sayHello();
              }
              return Expanded(child: MessagesScreen(messages: messages));
            },
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.teal.shade800,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))
            ),
            alignment: Alignment.bottomLeft,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Row(
              children: [
                Expanded(
                    child: TextField(
                  controller: _controller,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                )),
                IconButton(
                    onPressed: () => checkBeforeSending(_controller.text),
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
      _controller.text = words;
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

    Uri uri = Uri.parse("https://demo-bot.skyadav.repl.co/api/$text");
    debugPrint("Api Get Call : $uri");
    final response = await http.get(uri);
    String responseBody = utf8.decoder.convert(response.bodyBytes);
    final Map<String, dynamic> responseJson = json.decode(responseBody);
    debugPrint("Response : $responseJson");
    setState(() {
      addMessage(Message(text: DialogText(text: [responseJson['response']])));
      speak(responseJson['response']);
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

  checkBeforeSending(String input){
    if(input=='recommend'){
      showRecommendationDialog(context);
    }
    else{
      sendMessage(_controller.text);
    }
    _controller.clear();
  }


// location(BuildContext context) async {
//   print("LOC");
//   await Permission.location.serviceStatus.isEnabled;
//   print(Permission.location.serviceStatus.isEnabled);
//   _sendSMS(message, recipients);
// }

// void _sendSMS(String message, List<String> recipients) async {
//   String result = await sendSMS(
//           message: message, recipients: recipients, sendDirect: true)
//       .catchError((onError) {
//     print(onError);
//   });
//   print(result);
// }

// void playSound(BuildContext context) {
//   final player = AudioPlayer();
//   player.play(AssetSource('alarm.mpeg'));
//   QuickAlert.show(
//       context: context,
//       type: QuickAlertType.warning,
//       onConfirmBtnTap: () {
//         player.stop();
//         Navigator.pop(context);
//       });
// }

// camera(BuildContext context) {
//   NavigatorState state = Navigator.of(context);
//   state.pushNamedAndRemoveUntil('camera', (Route route) => false);
// }
}
