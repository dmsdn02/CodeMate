import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:code_mate/screen/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: LoginPage(), // MyLoginScreen을 홈 화면으로 설정
    ),
  );
}
