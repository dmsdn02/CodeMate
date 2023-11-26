import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_mate/screen/WritePage.dart';
import 'package:code_mate/screen/mypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainListPage(),
    );
  }
}

class MainListPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Color(0xFFF6E690),
        title: Text('메인페이지'),
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            var posts = snapshot.data!.docs;

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                var post = posts[index];
                String userId = post['userId'];

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                  builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                    if (userSnapshot.connectionState == ConnectionState.done) {
                      String userNickname = userSnapshot.data!.get('userNickname') ?? '';

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          surfaceTintColor: Colors.transparent,
                          color: Colors.white,
                          elevation: 3,
                          child: ListTile(
                            title: Text(
                              post['title'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('작성자: $userNickname'),
                                Text('Language: ${post['language']}'),
                                Text('Content: ${post['content']}'),
                              ],
                            ),
                            onTap: () {
                              // 클릭 시 수행할 동작 추가
                            },
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          elevation: 4,
                          child: ListTile(
                            title: Text('Loading...'),
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WritePage()),
          );
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0), // 둥근 테두리 반지름 설정
          side: BorderSide(color: Colors.grey, width: 1.0), // 테두리 두께 및 색상 설정
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        surfaceTintColor: Colors.transparent,
        color: Color(0xFFF6E690),
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainListPage()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.chat),
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
