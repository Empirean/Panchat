import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:panchat/pages/home/messages.dart';
import 'package:panchat/pages/home/panchatactions.dart';
import 'package:panchat/pages/home/people.dart';
import 'package:panchat/pages/home/profile.dart';
import 'package:panchat/pages/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:panchat/services/authenticate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: AuthenticationService().loginInfo,
      child: MaterialApp(
        color: Colors.black,
        home: Wrapper(),
        routes: {
          "/people" : (context) => People(),
          "/messages" : (context) => PanchatMessages(),
          "/actions" : (context) => PanchaActions(),
          "/profile" : (context) => Profile(),
        },
      ),
    );
  }
}

