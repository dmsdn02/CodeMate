import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_mate/screen/WritePage.dart';
import 'package:code_mate/screen/mypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'ChatList.dart';
import 'Information.dart';
import 'appbar.dart';

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
      appBar: CustomAppBar(title: '메인'),
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
                              // 클릭 시 InformationPage로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InformationPage(
                                    title: post['title'],
                                    content: post['content'] ?? '',
                                    userNickname: userNickname,
                                    language: post['language'] ?? '',
                                  ),
                                ),
                              );
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

      bottomNavigationBar: CustomBottomBar(
        // 바텀바에 대한 콜백 함수들 설정
        onMyPagePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPage()),
          );
        },
        onMainPagePressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainListPage()),
          );
        },
        onChatPressed: () {
          // Firebase Authentication을 통해 현재 사용자 가져오기
          FirebaseAuth _auth = FirebaseAuth.instance;
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
