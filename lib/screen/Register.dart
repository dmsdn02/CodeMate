import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login.dart';

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
  bool emailVerified = false;

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

      UserCredential userCredential;

      try {
        // 사용자에게 이메일 인증 메일 전송
        await _sendEmailVerification();

        // 여기에서 사용자에게 이메일 인증을 진행하도록 UI를 제공해야 합니다.
        // 사용자가 인증을 완료하면 Firestore에 정보 저장
        userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
      } catch (e) {
        // 이미 가입된 이메일이거나 인증된 이메일인 경우
        print("회원가입 실패: $e");
        setState(() {
          print("이미 인증된 이메일: $e");
        });
        return;
      }

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

  Future<void> _sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        print('이메일 인증 메일이 전송되었습니다. 이메일을 확인해주세요.');
      } else {
        print('이미 이메일이 인증되었습니다.');
      }
    } catch (e) {
      print('이메일 인증 메일 전송 실패: $e');
    }
  }

  //사용자의 이메일이 인증되었는지 확인하는 데 사용하는 함수인데, 이 코드에선 사용 X (혹시 몰라서 냅둠..)
  Future<void> _checkEmailVerification() async {
    User? user = _auth.currentUser;
    await user?.reload();
    user = _auth.currentUser;

    if (user != null && user.emailVerified) {
      print('이미 이메일이 인증되었습니다.');
    } else {
      print('이메일이 아직 인증되지 않았습니다.');
    }
  }

  void checkNicknameAvailability(String nickname) async {
    // 여기에서 비동기적인 작업 수행 (파이어베이스 데이터베이스 등에서 중복 확인)
    await Future.delayed(Duration(seconds: 2));
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
                            /*Container(
                              width: 100,
                              child: ElevatedButton(
                                onPressed: () async {
                                  await _sendEmailVerification();
                                  // 이메일 인증 상태 확인
                                  await _checkEmailVerification();
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
                showErrorMessage && isRegistered && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty && name.isNotEmpty && userNickname.isNotEmpty && gender.isNotEmpty
                    ? GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()), // 실제 로그인 페이지 위젯으로 변경해야 함
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                    : !isRegistered && showErrorMessage && email.isNotEmpty && password.isNotEmpty && confirmPassword.isNotEmpty && name.isNotEmpty && userNickname.isNotEmpty && gender.isNotEmpty
                    ? SizedBox(
                  child: Text(
                    '이미 가입된 이메일입니다.',
                    style: TextStyle(color: Colors.red, fontSize: 18),
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
