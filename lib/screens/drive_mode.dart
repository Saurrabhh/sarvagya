import 'package:flutter/material.dart';
import 'package:sarvagya/screens/botwheels_page.dart';

class DriveModePage extends StatefulWidget {
  const DriveModePage({Key? key}) : super(key: key);

  @override
  State<DriveModePage> createState() => _DriveModePageState();
}

class _DriveModePageState extends State<DriveModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detector'),
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Center(
      child: SizedBox(
        width: 240,
        height: 80,
        child: OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(
              const BorderSide(
                  color: Colors.blue, width: 1.0, style: BorderStyle.solid),
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BotWheelsPage(),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildIconWidget(Icons.arrow_forward_ios),
              const Text(
                'Go to Face Detector',
                style: TextStyle(fontSize: 20),
              ),
              _buildIconWidget(Icons.arrow_back_ios),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconWidget(final IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Icon(
        icon,
        size: 24,
      ),
    );
  }
}
