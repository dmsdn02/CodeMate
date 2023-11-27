import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:code_mate/screen/mainlist.dart';
import 'package:code_mate/screen/appbar.dart';

import 'ChatList.dart';

void main() {
  runApp(MaterialApp(
    home: MyPage(),
  ));
}

class MyPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: '마이페이지'), // CustomAppBar로 변경
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '회원 정보',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text('사용자 이름'),
                      subtitle: Text('user@example.com'),
                    ),
                    // 다른 회원 정보를 추가할 수 있습니다.
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextButton.icon(
              onPressed: () {
                // TODO: 로그아웃 기능 구현
              },
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
              label: Text(
                '로그아웃',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 10.0),
            TextButton.icon(
              onPressed: () {
                // TODO: 회원 탈퇴 기능 구현
              },
              icon: Icon(
                Icons.person_remove,
                color: Colors.black,
              ),
              label: Text(
                '회원 탈퇴',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        // 바텀바에 대한 콜백 함수들 설정
        onMyPagePressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPage()),
          );
        },
        onMainPagePressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainListPage()),
          );
        },
        onChatPressed: () async {
          // Firebase Authentication을 통해 현재 사용자 가져오기
          User? user = _auth.currentUser;

          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatList(userId: user.uid)),
            );
          }
        },
      ),
    );
  }
}