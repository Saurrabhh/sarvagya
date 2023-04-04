import 'dart:convert';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';
import 'package:camera/camera.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:sarvagya/screens/sentimental_analysis.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sarvagya/route_generator.dart';
import 'package:sarvagya/screens/botwheels_page.dart';
import 'package:sarvagya/screens/messages.dart';
import 'package:sarvagya/widgets/navigationDrawerWidget.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'firebase/firebase_options.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Permission.camera.request();
  await Permission.microphone.request();
  await Permission.location.request();
  await Permission.audio.request();
  await Permission.notification.request();
  await Permission.sms.request();
  await Permission.phone.request();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await checkUser();
  runApp(const MyApp());
}

// Future<void> checkUser() async {
//   if (FirebaseManager.auth.currentUser != null) {
//     final snapshot = await FirebaseManager.database
//         .ref('Users/${FirebaseManager.auth.currentUser!.uid}')
//         .get();
//     print(snapshot.value);
//     if (!snapshot.exists) {
//       await FirebaseManager.auth.signOut();
//       Fluttertoast.showToast(
//           msg: "^_^ You Got Deleted ^_^", toastLength: Toast.LENGTH_LONG);
//     }
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    // if(FirebaseAuth.instance.currentUser == null){
    //   return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     theme: ThemeData(
    //       primarySwatch: Colors.teal,
    //     ),
    //     initialRoute: 'verify',
    //     onGenerateRoute: RouteGenerator.generateRoute,
    //   );
    // }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      initialRoute: 'home',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> messages = [];
  String message = "This is a test message!";
  List<String> recipients = ["+919425253909", "8720068368"];
  SpeechToText speechToText = SpeechToText();
  bool _speechEnabled = false;
  var words = "hfkjjk";
  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);
    _initSpeech();
    super.initState();
  }

  void _initSpeech() async {
    _speechEnabled = await speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      words = result.recognizedWords;
      _controller.text = words;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    var isListening = false;

    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.,
      // floatingActionButton: AvatarGlow(
      //
      //   endRadius: 50.0,
      //   child: const Icon(Icons.mic),
      // ),
      appBar: AppBar(
        title: const Text(
          'Sarvagya',
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          ),
        ],
        // backgroundColor: const Color(0xff14122a),
      ),
      body: Column(
        children: [
          // Container(
          //   alignment: Alignment.topCenter,
          //   child: Text(
          //     // If listening is active show the recognized words
          //     speechToText.isListening
          //         ? words
          //         : _speechEnabled
          //         ? 'Tap the microphone to start listening...'
          //         : 'Speech not available',
          //   ),
          // ),
          Expanded(child: MessagesScreen(messages: messages)),

          Container(
            decoration: BoxDecoration(
                color: Colors.teal.shade800,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            alignment: Alignment.bottomLeft,
            width: width,
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
                    onPressed: () {
                      sendMessage(_controller.text);
                      _controller.clear();
                    },
                    icon: const Icon(Icons.send)),
                GestureDetector(
                  onTapDown: (details) {
                    print("Listening");
                    _startListening();
                  },
                  onTapUp: (details) {
                    _stopListening();
                  },
                  child: AvatarGlow(
                    animate: isListening,
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

  call(BuildContext context) {
    FlutterPhoneDirectCaller.callNumber("+916261934855");
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('No Message found');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      Uri uri = Uri.parse("https://demo-bot.skyadav.repl.co/api/$text");
      print("Api Get Call : $uri");
      final responsed = await http.get(uri);
      String responseBody = utf8.decoder.convert(responsed.bodyBytes);
      final Map<String, dynamic> responseJson = json.decode(responseBody);
      print("Response : $responseJson");

      setState(() {
        addMessage(Message(text: DialogText(text: [responseJson['response']])));
      });
      if (responseJson['response'].toString().contains('BotWheels')) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("BotWheels 🔥"),
              content: const Text(
                  "This will take you to BotWheels - Drive Mode Page"),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("DENY"),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BotWheelsPage()));
                    },
                    child: const Text("ALLOW")),
              ],
            );
          },
        );
      }
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }

  location(BuildContext context) async {
    print("LOC");
    await Permission.location.serviceStatus.isEnabled;
    print(Permission.location.serviceStatus.isEnabled);
    _sendSMS(message, recipients);
  }

  void _sendSMS(String message, List<String> recipients) async {
    String result = await sendSMS(
            message: message, recipients: recipients, sendDirect: true)
        .catchError((onError) {
      print(onError);
    });
    print(result);
  }

  void playSound(BuildContext context) {
    final player = AudioPlayer();
    player.play(AssetSource('alarm.mpeg'));
    QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        onConfirmBtnTap: () {
          player.stop();
          Navigator.pop(context);
        });
  }

  camera(BuildContext context) {
    NavigatorState state = Navigator.of(context);
    state.pushNamedAndRemoveUntil('camera', (Route route) => false);
  }
}
