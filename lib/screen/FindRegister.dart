import 'package:code_mate/screen/Register.dart';
import 'package:code_mate/screen/login.dart';
import 'package:flutter/material.dart';

class FindRegister extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Color(0xFFF6E690), // 앱바 배경색 설정
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 16.0), // padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // 왼쪽 정렬
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 30,
                  color: Colors.black,
                ),
                SizedBox(width: 10),
                Text(
                  '비밀번호 찾기',
                  style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '회원정보에 등록한 이메일을 입력해주세요.\n등록한 이메일로 비밀번호 재설정 메일이 발송됩니다.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.left, // 왼쪽 정렬
                ),
                SizedBox(height: 20),

                // 이메일 입력 폼
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: '이메일', // 이메일 입력
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // 비밀번호 재설정 버튼
                ElevatedButton(
                  onPressed: () {
                    // 비밀번호 재설정 로직 추가
                  },
                  child: Text(
                    '이메일 전송',
                    style: TextStyle(
                      color: Colors.black, // 텍스트 색상
                      fontSize: 15, // 폰트 크기
                      //fontWeight: FontWeight.bold, // 폰트 두께
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Color(0xFFFFF1B4)), // 버튼 배경색
                    minimumSize: MaterialStateProperty.all(Size(double.infinity, 50)), // 버튼의 최소 크기 설정
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0), // 원하는 가로 패딩 설정
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end, // 가로로 양 끝에 정렬
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );// 로그인 버튼 클릭 시 수행할 작업 추가
                  },
                  child: Text(
                    '로그인',
                    style: TextStyle(
                      color: Colors.grey, // 텍스트 색상 설정
                      fontSize: 16, // 텍스트 크기 설정
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );// 회원가입 버튼 클릭 시 수행할 작업 추가
                  },
                  child: Text(
                    '회원가입',
                    style: TextStyle(
                      color: Colors.grey, // 텍스트 색상 설정
                      fontSize: 16, // 텍스트 크기 설정
                    ),
                  ),
                ),
              ], // children
            ),
          )
        ], // children
      ),
    );
  }
}
