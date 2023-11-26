import 'package:flutter/material.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
      ),
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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyPage(),
  ));
}
