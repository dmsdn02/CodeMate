import 'package:code_mate/screen/WritePage.dart';
import 'package:code_mate/screen/mypage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainListPage(), // 채팅방 목록 페이지를 홈으로 설정
    );
  }
}

class MainListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('메인페이지'),
      ),
      body: ListView(
        children: <Widget>[
          ChatListItem('친구 1', '최근 메시지 1', '10:30 AM'),
          ChatListItem('친구 2', '최근 메시지 2', 'Yesterday'),
          ChatListItem('친구 3', '최근 메시지 3', 'Nov 5'),
          // 원하는 만큼 채팅방 항목을 추가
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // + 버튼이 눌리면 WritePage로 이동
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WritePage()),
          );
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.settings), // My Page 아이콘
              onPressed: () {
                // My Page 버튼이 탭되면 MyPage로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => mypage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // 홈 버튼이 탭되면 MainListPage로 이동
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainListPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.chat), // My Page 아이콘
              onPressed: () {
                // 채팅방 페이지로 연결
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  final String friendName;
  final String recentMessage;
  final String lastActive;

  ChatListItem(this.friendName, this.recentMessage, this.lastActive);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        // 친구 프로필 이미지 설정
        backgroundImage: AssetImage('assets/profile_image.png'),
      ),
      title: Text(friendName),
      subtitle: Text(recentMessage),
      trailing: Text(lastActive),
      onTap: () {
        // 해당 채팅방 항목을 클릭했을 때 수행할 작업 추가
        // 예를 들어, 채팅방으로 이동하거나 채팅 상세 정보를 표시할 수 있음
      },
    );
  }
}
