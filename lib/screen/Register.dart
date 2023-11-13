import 'package:flutter/material.dart';

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
  // 비밀번호
  String password = "";

  // 비밀번호 비교
  String checkPassword = "";

  String passwordCheck = "";
  String nickname = ""; // 닉네임 입력값을 저장하는 변수

  // 닉네임 중복 확인 함수
  void checkNicknameAvailability(String nickname) {
    // 여기에 닉네임 중복 확인 로직을 구현합니다.
    // 중복 확인 로직을 통과하면 사용 가능한 닉네임으로 설정하세요.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6E690),
      body: SingleChildScrollView( // 스크롤 가능하도록 추가
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
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // 닉네임 중복 확인 버튼 클릭 시 수행할 작업
                                final nickname = "닉네임 입력란의 값을 가져와주세요"; // 닉네임 입력란의 값을 가져와 변수에 저장
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
