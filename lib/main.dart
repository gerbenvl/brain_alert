import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BrainAlert extends StatefulWidget {
  @override
  BrainAlertState createState() => BrainAlertState();
}

class BrainAlertState extends State<BrainAlert> {
  String _homeMessageText = "Loading...";

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize
      await Firebase.initializeApp();
      subscribeToTopic();
      registerMessageHandlers();
    } catch (e) {
      setState(() {
        _homeMessageText = "Error initializing firebase";
      });
    }
  }

  void subscribeToTopic() {
    FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    firebaseMessaging.subscribeToTopic("Test").then((val) {
      setState(() {
        _homeMessageText =
            "Waiting for messages. You can close the application now, notifications will popup.\r\n";
      });
    });
  }

  void registerMessageHandlers() {
    // Voor als de app open staat, want dan komen er geen notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      setState(() {
        _homeMessageText += makeLogMessage(message.notification.title);
      });
    });
  }

  String makeLogMessage(String title) {
    var now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy HH:MM:ss');
    String formattedNow = formatter.format(now);
    String logMessage = "Notification for: '$title' at $formattedNow.\r\n";
    return logMessage;
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _biggerFont = const TextStyle(fontSize: 16.0);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Brainiacs Alert'),
        ),
        body: Material(
          child: Column(
            children: <Widget>[
              Row(children: <Widget>[
                Expanded(
                  child: Text(_homeMessageText, style: _biggerFont),
                ),
              ]),
            ],
          ),
        ));
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: BrainAlert(),
    ),
  );
}
