import 'package:flutter/material.dart';
import 'package:sarvagya/screens/drawer_screens/recommendation.dart';

import '../screens/drawer_screens/botwheels_page.dart';
import '../screens/drawer_screens/sentimental_analysis.dart';

showBotWheelsDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("BotWheels 🔥"),
        content:
            const Text("This will take you to BotWheels - Drive Mode Page"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("DENY"),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const BotWheelsPage()));
              },
              child: const Text("ALLOW")),
        ],
      );
    },
  );
}

showSmilePleaseDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Smile Please 😁"),
        content: const Text(
            "This will take you to Smile Please - Sentimental Analysis Page"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("DENY"),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const SentimentalPage()));
              },
              child: const Text("ALLOW")),
        ],
      );
    },
  );
}

showRecommendationDialog(BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Recommendation"),
        content: const Text(
            "This will take you to recommendation page"),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("DENY"),
          ),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const Recommendation()));
              },
              child: const Text("ALLOW")),
        ],
      );
    },
  );
}
