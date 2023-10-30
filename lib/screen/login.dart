import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFCEA8A), // 배경색 설정

      body: Center(
        child: Container(
          width: 320, // 네모박스의 너비 설정
          padding: EdgeInsets.all(7), // 네모박스 내부 패딩 설정
          decoration: BoxDecoration(
            color: Colors.white, // 네모박스 배경색 설정
            borderRadius: BorderRadius.circular(20), // 둥근 네모박스를 위한 BorderRadius 설정
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // 이메일 입력란
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: '이메일',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.email), // 아이콘 추가
                  ),
                  style: TextStyle(
                    color: Colors.grey, // 글자 색상 지정
                  ),
                ),
              ),
              Divider(height: 20, color: Colors.grey[400]), // 가로선 추가
              // 비밀번호 입력란
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: '비밀번호',
                    filled: true,
                    fillColor: Colors.white,
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock), // 아이콘 추가
                  ),
                  style: TextStyle(
                    color: Colors.grey[50], // 글자 색상 지정
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
