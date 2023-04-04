import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sarvagya/utils/face_detector_painter.dart';
import 'camera_view.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class SentimentalPage extends StatefulWidget {
  const SentimentalPage({Key? key}) : super(key: key);

  @override
  State<SentimentalPage> createState() => _SentimentalPageState();
}

class _SentimentalPageState extends State<SentimentalPage> {
  int noSmileCount = 0;

  //create face detector object
  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: true,
      enableClassification: true,
    ),
  );
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        CameraView(
          title: 'Smile Please',
          customPaint: _customPaint,
          text: _text,
          onImage: (inputImage) {
            processImage(inputImage);
          },
          initialDirection: CameraLensDirection.front,
          showWidget: smileGIF(),
        ),
        // Positioned(
        //   child: Align(
        //     alignment: Alignment.center,
        //     child: Column(
        //       children: [
        //         Text(noSmileCount.toString()),
        //         Text(alarmCount.toString()),
        //         Text(yawningCount.toString()),
        //       ],
        //     ),
        //   ),
        // )
      ]),
    );
  }

  Widget smileGIF() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "When I smile you smile..😁",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Image.asset(
            "assets/smile.gif",
            height: 300,
            fit: BoxFit.fitWidth,
          ),
        ],
      ),
    );
  }

  void playSound(BuildContext context) {
    final player = AudioPlayer();
    player.play(AssetSource('plzSmile.mp3'));
    QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        onConfirmBtnTap: () {
          player.stop();
          Navigator.pop(context);
        });
  }

  camera(BuildContext context) {
    NavigatorState state = Navigator.of(context);
    state.pushNamedAndRemoveUntil('camera', (Route route) => false);
  }

  Future<void> processImage(final InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    final faces = await _faceDetector.processImage(inputImage);
    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = FaceDetectorPainter(
          faces,
          inputImage.inputImageData!.size,
          inputImage.inputImageData!.imageRotation);
      _customPaint = CustomPaint(painter: painter);

      for (final face in faces) {
        double averageEyeOpenProb =
            (face.leftEyeOpenProbability! + face.rightEyeOpenProbability!) /
                2.0;
        if (face.smilingProbability! < 0.4) {
          print("\n\n........NOT SMILING........\n\n");
          setState(() {
            noSmileCount = noSmileCount + 1;
          });

          if (noSmileCount > 10) {
            noSmileCount = 0;
            playSound(context);
          }
        } else {
          noSmileCount = 0;
        }
      }
    } else {
      String text = 'face found ${faces.length}\n\n';

      for (final face in faces) {
        text += 'face ${face.boundingBox}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }
}
