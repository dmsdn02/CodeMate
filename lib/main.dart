import 'package:code_mate/screen/chat.dart';
import 'package:code_mate/screen/login.dart';
import 'package:code_mate/screen/mainlist.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:web_socket_channel/io.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBk3kvNILmP4mt-pviZt1zR1fSDXAErbgA",
      authDomain: "codemate-b0880.firebaseapp.com",
      projectId: "codemate-b0880",
      storageBucket: "codemate-b0880.appspot.com",
      messagingSenderId: "140738075473",
      appId: "1:140738075473:web:b5d73b1e539c8f2fed9170",
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainListPage(),
    );
  }
}
