import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:sarvagya/utils/face_detector_painter.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'camera_view.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectorPage extends StatefulWidget {
  const FaceDetectorPage({Key? key}) : super(key: key);

  @override
  State<FaceDetectorPage> createState() => _FaceDetectorPageState();
}
String message = "This is a test message!";
List<String> recipients = ["+919425253909", "8720068368"];

class _FaceDetectorPageState extends State<FaceDetectorPage> {
  int alarmCount = 0;
  int drowsyCount = 0;
  int yawningCount = 0;

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
    return CameraView(
      title: 'Face Detector',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
      initialDirection: CameraLensDirection.front,
    );
  }

  location(BuildContext context) async {
    print("LOC");
    await Permission.location.serviceStatus.isEnabled;
    print(Permission.location.serviceStatus.isEnabled);
    _sendSMS(message, recipients);
  }

  // void _sendSMS(String message, List<String> recipients) async {
  //   String _result = await sendSMS(
  //       message: message, recipients: recipients, sendDirect: true)
  //       .catchError((onError) {
  //     print(onError);
  //   });
  //   print(_result);
  // }

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

  call(BuildContext context) {
    FlutterPhoneDirectCaller.callNumber("+916261934855");
  }


  camera(BuildContext context) {
    NavigatorState state = Navigator.of(context);
    state.pushNamedAndRemoveUntil('camera', (Route route) => false);
  }

  Future<void> processImage(final InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    _isBusy = true;
    setState(() {
      _text = "";
    });
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
        if (averageEyeOpenProb < 0.6 ||
            (face.leftEyeOpenProbability! < 0.3 &&
                face.rightEyeOpenProbability! < 0.3)) {
          print("\n........SLEEPING........\n");
          setState(() {
            // widget.alertSleepingText = "Driver is feeling drowsy";
            drowsyCount = drowsyCount + 1;
          });
          if (drowsyCount > 8) {
            setState(() {
              alarmCount = alarmCount + 1;
            });
            playSound(context);
            print(alarmCount);
            drowsyCount = 0;
            print(" ALARM !!!    WAKE UP DUDE...");
            //drowsy count is set back to 0
            if (alarmCount > 2 && alarmCount <= 4) {
              getLatLong();
              print("send");
              // SEND SMS
            }
            if (alarmCount > 4) {
             call(context);
              setState(() {
                alarmCount = 0;
              });
            }

            //maintain alarmCount,    if alarm is played more than 2 times,   send sms/call
          }
        } else {
          setState(() {
            drowsyCount = 0;
            // widget.alertSleepingText = "Driver is not feeling drowsy";
          });
        }

        print(face.smilingProbability);
        if ((0.02 < face.smilingProbability! &&
                face.smilingProbability! < 0.2) &&
            (face.leftEyeOpenProbability! < 0.86 &&
                face.rightEyeOpenProbability! < 0.86)) {
          print("\n........YAWNING........\n");
          setState(() {
            // widget.alertYawningText = "Driver is Yawning";
            yawningCount = yawningCount + 1;
          });

          if (yawningCount > 5) {
            playSound(context);
            // getLatLong();
            yawningCount = 0;
            setState(() {
              alarmCount = alarmCount + 1;
            });
            //play alarm sound until driver stops it
            // if driver stops the alarm, yawning count is set back to 0
            print(" ALARM !!!    WAKE UP DUDE...");
            if (alarmCount > 2 && alarmCount <= 4) {
              getLatLong();
              print("send");
              // SEND SMS
            }
            if (alarmCount > 4) {
              call(context);
              setState(() {
                alarmCount = 0;
              });
            }

            //maintain alramCount,    if alarm is played more than 2 times,   send sms/call
          }
        } else {
          setState(() {
            yawningCount = 0;
            // widget.alertYawningText = "Driver is not yawning";
          });
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

  double? lat;

  double? long;

  String address = "";

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      print("value $value");
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });

      getAddress(value.latitude, value.longitude);
    }).catchError((error) {
      print("Error $error");
    });
  }

//For convert lat long to address
  getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    setState(() {
      address = placemarks[0].street! +
          ", " +
          placemarks[0].subAdministrativeArea! +
          ", " +
          placemarks[0].administrativeArea!;
    });

    for (int i = 0; i < placemarks.length; i++) {
      print("INDEX $i ${placemarks[i]}");
    }
    print(address);
    String message =
        "This person is feeling drowsy and their current location is: " +
            " " +
            address;
    List<String> recipients = [
      "+919425253909",
      "8720068368",
      "8319499826",
      "9669215218"
    ];
    _sendSMS(message, recipients);
  }

  void _sendSMS(String message, List<String> recipients) async {
    String _result = await sendSMS(
            message: message, recipients: recipients, sendDirect: true)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
}
