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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 300, // 네모박스의 가로길이 조절 가능
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey[200], // 배경색 설정
              ),
              child: Column(
                children: <Widget>[
                  TextField(
                    decoration: InputDecoration(
                      hintText: '이메일',
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    obscureText: true, // 비밀번호 필드로 설정
                    decoration: InputDecoration(
                      hintText: '비밀번호',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // 로그인 버튼 클릭 시 수행할 동작 설정
                    },
                    child: Text('로그인'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    // 회원가입 버튼 클릭 시 수행할 동작 설정
                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // 비밀번호 찾기 버튼 클릭 시 수행할 동작 설정
                  },
                  child: Text(
                    '비밀번호 찾기',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
