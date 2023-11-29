import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'FindRegister.dart';
import 'Register.dart';
import 'mainlist.dart'; // mainlist.dart 페이지 파일을 import

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
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6E690), // 배경색 설정
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // 이미지 추가
            Image.asset(
              'lib/image/main_icon.png', // 이미지 파일 경로
              width: 80, // 이미지의 가로 길이 설정
              height: 80, // 이미지의 세로 길이 설정
            ),
            SizedBox(height: 10), // 이미지와 텍스트 사이에 픽셀 여백 추가

            // 텍스트 추가
            Text(
              'CodeMate',
              style: TextStyle(
                fontSize: 27, // 텍스트 크기 설정
                fontWeight: FontWeight.bold, // 텍스트 굵기 설정
                color: Colors.black, // 텍스트 색상 설정
              ),
            ),
            SizedBox(height: 23),
            Container(
              width: 320, // 네모박스의 너비 설정
              padding: EdgeInsets.all(6), // 네모박스 내부 패딩 설정
              decoration: BoxDecoration(
                color: Colors.white, // 네모박스 배경색 설정
                borderRadius: BorderRadius.circular(12), // 둥근 네모박스를 위한 BorderRadius 설정
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  // 이메일 입력란
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: '이메일',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.email, color: Colors.grey[400]), // 아이콘 추가
                      ),
                      style: TextStyle(
                        color: Colors.black, // 글자 색상을 검은색으로 지정
                      ),
                    ),
                  ),
                  // 가로선 추가
                  Container(
                    height: 0.8,
                    width: double.infinity,
                    color: Colors.grey[300],
                  ),
                  // 비밀번호 입력란
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true, // 비밀번호를 가리기 위해 사용
                      decoration: InputDecoration(
                        labelText: '비밀번호',
                        filled: true,
                        fillColor: Colors.white,
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock, color: Colors.grey[400]), // 아이콘 추가
                      ),
                      style: TextStyle(
                        color: Colors.black, // 글자 색상을 검은색으로 지정
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // 로그인 버튼과 입력란 사이의 공간 추가
            Container(
              width: 310, // 원하는 가로 길이로 설정
              height: 45, // 원하는 세로 길이로 설정
              child: ElevatedButton(
                onPressed: () async {
                  // 로그인 버튼 클릭 시 수행할 작업 추가
                  String enteredEmail = emailController.text;
                  String enteredPassword = passwordController.text;

                  try {
                    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                      email: enteredEmail,
                      password: enteredPassword,
                    );

                    User? user = userCredential.user;

                    if (user != null) {
                      if (user.emailVerified) {
                        // 이메일이 인증된 경우
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MainListPage()),
                        );
                      } else {
                        // 이메일이 인증되지 않은 경우
                        // 사용자에게 인증 메일을 확인하라는 메시지를 보여줄 수 있습니다.
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('이메일 인증 필요'),
                              content: Text('이메일을 확인하고 인증해주세요.'),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('확인'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      // 사용자가 null인 경우 처리 (에러 또는 예외 상황)
                      print('사용자 정보가 없습니다.');
                    }
                  } catch (e) {
                    // 로그인에 실패한 경우
                    print("로그인 실패: $e");

                    // 이메일 또는 비밀번호가 틀렸음을 알리는 다이얼로그 표시
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('로그인 실패'),
                          content: Text('이메일 또는 비밀번호가 잘못되었습니다.'),
                          actions: <Widget>[
                            TextButton(
                              child: Text('확인'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[300], // 버튼 색상 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 둥근 네모박스 버튼
                  ),
                ),
                child: Text(
                  '로그인',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            ),
            SizedBox(height: 15), // 로그인 버튼과 회원가입 버튼 사이의 공간 추가
            Container(
              width: 310, // 가로 길이
              height: 45, // 세로 길이
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[100], // 버튼 색상 설정
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // 둥근 네모박스 버튼
                  ),
                ),
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    color: Colors.brown[400],
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            //SizedBox(height: 1), // 버튼과 텍스트 버튼 사이의 공간 추가
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FindRegister()),
                );// 비밀번호 찾기 페이지로 이동
              },
              child: Text(
                '비밀번호 찾기',
                style: TextStyle(
                  color: Colors.grey, // 텍스트 색상 설정
                  fontSize: 14, // 텍스트 크기 설정
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}