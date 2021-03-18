import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class PushMessaging extends StatefulWidget {
  @override
  _PushMessagingState createState() => _PushMessagingState();
}

class _PushMessagingState extends State<PushMessaging> {
  String _bottomMessageText = "";
  String _homeMessageText = "Loading...";

// Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

        firebaseMessaging.getToken().then((String token) {
          assert(token != null);
          setState(() {
            _bottomMessageText = "Push Messaging token: " + token;
            _homeMessageText =
                "Waiting for messages. You can close the application now, notifications will popup.";
          });
        });
      });
    } catch (e) {
      setState(() {
        _homeMessageText = "Error initializing firebase";
      });
    }
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
              Spacer(),
              Center(
                child: Text(_bottomMessageText),
              ),
            ],
          ),
        ));
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      home: PushMessaging(),
    ),
  );
}
