import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RegisterPage(),
    );
  }
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 비밀번호
  String password = "";

  // 비밀번호 확인
  String checkPassword = "";

  // 닉네임
  String nickname = ""; // 닉네임 입력값을 저장하는 변수

  // 닉네임 중복 확인 함수
  Future<void> checkNicknameAvailability(String nickname) async {
    try {
      // Firebase 데이터베이스에서 닉네임이 있는지 확인
      var snapshot = await _firestore
          .collection('users')
          .where('nickname', isEqualTo: nickname)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // 닉네임이 이미 존재할 경우
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("중복 확인"),
              content: Text("이미 존재하는 닉네임입니다."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("확인"),
                ),
              ],
            );
          },
        );
      } else {
        // 닉네임이 존재하지 않을 경우
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("중복 확인"),
              content: Text("사용 가능한 닉네임입니다."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("확인"),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print("Error checking nickname availability: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6E690),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('회원가입', style: TextStyle(fontSize: 27.0, fontWeight: FontWeight.bold)),
                SizedBox(height: 23.0),
                Container(
                  width: 320,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // 이메일 입력란, 비밀번호 입력란, 비밀번호 확인란, 이름 입력, 닉네임 입력, 성별 선택
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: '이메일',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.email_outlined, color: Colors.grey[400]),
                                ),
                                style: TextStyle(
                                  color: Colors.grey[100],
                                ),
                              ),
                            ),
                            Container(
                              width: 100, // 버튼의 너비를 설정
                              child: ElevatedButton(
                                onPressed: () {
                                  // 이메일 인증 버튼 클릭 시 수행할 작업 추가
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[400], // 버튼 색상 설정
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: Size(90, 40), // 버튼의 최소 크기를 지정
                                ),
                                child: Text(
                                  '이메일인증',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 가로선 추가
                      Container(
                        height: 0.8,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      // 비밀번호 입력
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none, // 여기서 오류를 수정했습니다
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                          ),
                          style: TextStyle(
                            color: Colors.grey[100],
                          ),
                        ),
                      ),
                      // 가로선 추가
                      Container(
                        height: 0.8,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      // 비밀번호 확인
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '비밀번호 확인',
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                          ),
                          style: TextStyle(
                            color: Colors.grey[100],
                          ),
                        ),
                      ),
                      // 가로선 추가
                      Container(
                        height: 0.8,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      // 이름 입력
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '이름',
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.person_outline, color: Colors.grey[400]),
                          ),
                          style: TextStyle(
                            color: Colors.grey[100],
                          ),
                        ),
                      ),
                      // 가로선 추가
                      Container(
                        height: 0.8,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      // 닉네임 입력
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  labelText: '닉네임',
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.account_circle, color: Colors.grey[400]),
                                ),
                                style: TextStyle(
                                  color: Colors.grey[100],
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    nickname = value;
                                  });
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // 닉네임 중복 확인 버튼 클릭 시 수행할 작업
                                checkNicknameAvailability(nickname);
                              },
                              style: ElevatedButton.styleFrom(
                                primary: Colors.grey[400], // 버튼 색상 설정
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(90, 40), // 버튼의 최소 크기를 지정
                              ),
                              child: Text(
                                '중복 확인',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 가로선 추가
                      Container(
                        height: 0.8,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      // 성별 선택
                      Container(
                        height: 50.0,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.male_outlined, color: Colors.grey[400]),
                            Icon(Icons.female_outlined, color: Colors.grey[400]),
                            SizedBox(width: 30),
                            Radio(
                              value: "남",
                              groupValue: null,
                              onChanged: null,
                            ),
                            Text(
                              "남",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(width: 20),
                            Radio(
                              value: "여",
                              groupValue: null,
                              onChanged: null,
                            ),
                            Text(
                              "여",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 310, // 원하는 가로 길이로 설정
                  height: 45, // 원하는 세로 길이로 설정
                  child: ElevatedButton(
                    onPressed: () {
                      // 회원가입 버튼 클릭 시 수행할 작업 추가
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFFFF1B4), // 버튼 색상 설정
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // 둥근 네모박스 버튼
                      ),
                    ),
                    child: Text(
                      '가입하기',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
