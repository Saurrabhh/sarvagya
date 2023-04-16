import 'package:flutter/material.dart';
import 'package:sarvagya/screens/auth_screens/code_verify.dart';
import 'package:sarvagya/screens/auth_screens/login_screen.dart';
import 'package:sarvagya/screens/auth_screens/phone_verify.dart';
import 'package:sarvagya/screens/auth_screens/signup_screen.dart';
import 'package:sarvagya/screens/drive_mode.dart';
import 'package:sarvagya/screens/main_dashboard.dart';


class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {

    switch (settings.name) {
      // case 'verify':
      //   return MaterialPageRoute(builder: (_) => PhoneVerify());
      case 'home':
        return MaterialPageRoute(builder: (_) => const MainDashboard());
      case 'login':
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case '/signup':
        return MaterialPageRoute(
            builder: (_) => SignupScreen());
      case 'camera':
        return MaterialPageRoute(builder: (_) => const DriveModePage());
      // case '/verifyOtp':
      //   return MaterialPageRoute(
      //       builder: (_) => verifyOtp(
      //             args: args as List<String>,
      //           ));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
