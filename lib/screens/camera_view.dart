import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:sarvagya/main.dart';
import 'buttonWidget.dart';
import 'dart:async';

class CameraView extends StatefulWidget {
  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final CameraLensDirection initialDirection;

  CameraView({
    Key? key,
    required this.title,
    required this.onImage,
    required this.initialDirection,
    this.customPaint,
    this.text,
  }) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  static const maxSeconds = 60;
  static const minSeconds = 0;
  int seconds = minSeconds;
  Timer? timer;

  void resetTimer() => setState(() => seconds = minSeconds);
  CameraController? _controller;
  int _cameraIndex = 0;
  bool _chagingCameraLens = false;

  @override
  void initState() {
    super.initState();
    if (cameras.any(
      (element) =>
          element.lensDirection == widget.initialDirection &&
          element.sensorOrientation == 99,
    )) {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
          (element) =>
              element.lensDirection == widget.initialDirection &&
              element.sensorOrientation == 99,
        ),
      );
    } else {
      _cameraIndex = cameras.indexOf(
        cameras.firstWhere(
            (element) => element.lensDirection == widget.initialDirection),
      );
    }
    _startLive();
  }

  Future _startLive() async {
    final camera = cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      _controller?.startImageStream(_processCameraImage);
      setState(() {});
    });
  }

  Future _processCameraImage(final CameraImage image) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();
    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );
    final camera = cameras[_cameraIndex];
    final imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation) ??
            InputImageRotation.rotation0deg;
    final inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw) ??
            InputImageFormat.nv21;
    final planeData = image.planes.map((final Plane plane) {
      return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width);
    }).toList();
    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: imageRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );
    final inputImage = InputImage.fromBytes(
      bytes: bytes,
      inputImageData: inputImageData,
    );
    widget.onImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: const Text(
              "Keep your face inside the frame",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ClipOval(child: _liveBody()),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTimer(),
              const SizedBox(height: 30),
              buildButtons()
            ],
          ),
        ],
      ),
      floatingActionButton: _floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget? _floatingActionButton() {
    if (cameras.length == 1) return null;
    return SizedBox(
      height: 70,
      width: 70,
      child: FloatingActionButton(
        onPressed: _switchCamera,
        child: const Icon(
          Icons.flip_camera_ios_outlined,
          size: 40,
        ),
      ),
    );
  }

  Future _switchCamera() async {
    setState(() {
      _chagingCameraLens = true;

      if (_cameraIndex == 0) {
        _cameraIndex = 1;
      } else {
        _cameraIndex = 0;
      }
    });
    await _startLive();
    await _startLive();
    setState(() {
      _chagingCameraLens = false;
    });
  }

  Widget _liveBody() {
    if (_controller?.value.isInitialized == false) {
      return Container(
          child: CircularProgressIndicator(
        strokeWidth: 4.0,
        color: Colors.red,
      ));
    }
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width * 0.5,
      color: Colors.black,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_controller!),
          if (widget.customPaint != null) widget.customPaint!
        ],
      ),
    );
  }

  Future _stopLive() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Widget buildButtons() {
    final isRunning = timer == null ? false : timer!.isActive;
    final isCompleted = seconds == 60;

    return isRunning
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ButtonWidget(
                text: isRunning ? 'Pause' : 'Resume',
                onClicked: () {
                  if (isRunning) {
                    stopTimer(reset: false);
                  } else {
                    startTimer(reset: false);
                  }
                },
              ),
              const SizedBox(width: 12),
              ButtonWidget(text: 'Cancel', onClicked: stopTimer)
            ],
          )
        : ButtonWidget(
            text: "Start",
            onClicked: () {
              startTimer();
            },
          );
  }

  Widget buildTimer() => SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: 1 - seconds / maxSeconds,
              valueColor: AlwaysStoppedAnimation(Colors.red),
              strokeWidth: 12,
              backgroundColor: Colors.white,
            ),
            Center(child: buildTime()),
          ],
        ),
      );

  Widget buildTime() {
    return Text('$seconds',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
          fontSize: 80,
        ));
  }

  void startTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (seconds < 7200) {
        setState(() => seconds++);
      } else {
        stopTimer(reset: false);
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    setState(() => timer?.cancel());
  }
}
