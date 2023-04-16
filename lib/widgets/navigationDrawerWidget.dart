import 'package:flutter/material.dart';
import 'package:sarvagya/screens/drawer_screens/botwheels_page.dart';
import 'package:sarvagya/screens/drawer_screens/recommendation.dart';
import 'package:sarvagya/screens/drawer_screens/sentimental_analysis.dart';
import '../firebase/firebase_manager.dart';
import '../screens/drawer_screens/ProfileScreen.dart';

class NavigationDrawerWidget extends StatelessWidget {
  const NavigationDrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: 250,
        child: Material(
          child: ListView(
            children: <Widget>[
              // const SizedBox(
              //   height: 40,
              // ),
              // buildMenuItem(
              //   drawerText: 'Profile',
              //   drawerIcon: Icons.person,
              //   onClicked: () => selectedItem(context, 0),
              // ),
              // const SizedBox(
              //   height: 20,
              // ),
              buildMenuItem(
                drawerText: 'Bot Wheels',
                drawerIcon: Icons.car_repair,
                onClicked: () => selectedItem(context, 2),
              ),
              const SizedBox(
                height: 20,
              ),
              buildMenuItem(
                drawerText: 'Smile Please',
                drawerIcon: Icons.insert_emoticon_outlined,
                onClicked: () => selectedItem(context, 3),
              ),
              const SizedBox(
                height: 20,
              ),
              buildMenuItem(
                drawerText: 'Recommendation',
                drawerIcon: Icons.book,
                onClicked: () => selectedItem(context, 4),
              ),
              const SizedBox(
                height: 20,
              ),
              const Divider(color: Colors.black),
              const SizedBox(
                height: 20,
              ),
              buildMenuItem(
                drawerText: 'LogOut',
                drawerIcon: Icons.logout,
                onClicked: () => selectedItem(context, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String drawerText,
    required IconData drawerIcon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.black;
    return ListTile(
      leading: Icon(
        drawerIcon,
        color: color,
      ),
      title: Text(drawerText),
      onTap: onClicked,
    );
  }

  Future<void> selectedItem(BuildContext context, int i) async {
    Navigator.of(context).pop();
    switch (i) {
      case 0:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProfileScreen()));
        break;
      case 1:
        await FirebaseManager.auth.signOut();
        Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
        break;
      case 2:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const BotWheelsPage()));
        break;
      case 3:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const SentimentalPage()));
        break;
      case 4:
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const Recommendation()));
        break;
    }
  }
}
