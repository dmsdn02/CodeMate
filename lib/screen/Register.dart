import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';

//void main() async {
//runApp(MyApp());
//}

//class MyApp extends StatelessWidget {
//@override
//Widget build(BuildContext context) {
//return MaterialApp(
//home: RegisterPage(),
//  );
//}
//}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String email = "";
  String password = "";
  String confirmPassword = "";
  String name = "";
  String userNickname = "";
  String gender = "";

  bool isRegistered = false;
  bool showErrorMessage = false;

  void _register() async {
    setState(() {
      showErrorMessage = true;
    });

    try {
      if (email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty ||
          name.isEmpty ||
          userNickname.isEmpty ||
          gender.isEmpty) {
        print("정보를 입력해주세요.");
        setState(() {
          isRegistered = false;
        });
        return;
      }

      if (password != confirmPassword) {
        print("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
        return;
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': email,
        'name': name,
        'userNickname': userNickname,
        'gender': gender,
      });

      setState(() {
        isRegistered = true;
      });
    } catch (e) {
      print("회원가입 실패: $e");
    }
  }

  void checkNicknameAvailability(String nickname) async {
    // 여기에서 비동기적인 작업 수행 (파이어베이스 데이터베이스 등에서 중복 확인)

    // 예시: Future.delayed를 사용하여 2초 동안 기다리는 작업을 수행한다고 가정
    await Future.delayed(Duration(seconds: 2));

    // 중복 확인 로직을 통과하면 사용 가능한 닉네임으로 설정하세요.
    print('Nickname $nickname is available!');
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
                SizedBox(height: 80.0),
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
                                  color: Colors.black,
                                ),
                                onChanged: (value) {
                                  email = value;
                                },
                              ),
                            ),
                            /* 이메일 인증 버튼
                            Container(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () {
                                  // 이메일 인증 버튼 클릭 시 수행할 작업 추가
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[400],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  minimumSize: Size(90, 40),
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
                            ),*/
                          ],
                        ),
                      ),
                      Container(
                        height: 0.8,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          decoration: InputDecoration(
                            labelText: '비밀번호',
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.grey[400]),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            password = value;
                          },
                        ),
                      ),
                      Container(
                        height: 0.8,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
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
                            color: Colors.black,
                          ),
                          obscureText: true,
                          onChanged: (value) {
                            confirmPassword = value;
                          },
                        ),
                      ),
                      Container(
                        height: 0.8,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
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
                            color: Colors.black,
                          ),
                          onChanged: (value) {
                            name = value;
                          },
                        ),
                      ),
                      Container(
                        height: 0.8,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),

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
                                  color: Colors.black,
                                ),
                                onChanged: (value) {
                                  userNickname = value;
                                },
                              ),
                            ),
                            /* 닉네임 중복확인 버튼
                            ElevatedButton(
                              onPressed: () {
                                checkNicknameAvailability(nickname);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                minimumSize: Size(90, 40),
                              ),
                              child: Text(
                                '중복 확인',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                      Container(
                        height: 0.8,
                        width: double.infinity,
                        color: Colors.grey[300],
                      ),
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
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              },
                            ),
                            Text(
                              "남",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(width: 20),
                            Radio(
                              value: "여",
                              groupValue: gender,
                              onChanged: (value) {
                                setState(() {
                                  gender = value.toString();
                                });
                              },
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
                  width: 310,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      _register();
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFF1B4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2, // 그림자 추가
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
                SizedBox(height: 20.0),
                showErrorMessage && !isRegistered && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty && name.isNotEmpty && userNickname.isNotEmpty && gender.isNotEmpty
                    ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()), // 실제 로그인 페이지 위젯으로 변경해야 해
                    );
                  },
                  child: SizedBox(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.brown, fontSize: 17),
                        children: [
                          TextSpan(
                            text: '  가입이 완료되었습니다.\n',
                          ),
                          TextSpan(
                            text: '로그인 페이지로 이동하기',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.bold,
                              // 밑줄 스타일을 설정할 수 있어요.
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    : SizedBox.shrink(),
                //SizedBox(height: 20),
                !isRegistered &&
                    showErrorMessage &&
                    (email.isEmpty ||
                        password.isEmpty ||
                        confirmPassword.isEmpty ||
                        name.isEmpty ||
                        userNickname.isEmpty ||
                        gender.isEmpty)
                    ? SizedBox(
                  //height: 10,
                  child: Text(
                    '정보를 입력하세요.',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                )
                    : SizedBox.shrink(),
                //SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}