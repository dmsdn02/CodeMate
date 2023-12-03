import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_mate/screen/WritePage.dart';
import 'package:code_mate/screen/mypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class MainListPage extends StatefulWidget {
  @override
  _MainListPageState createState() => _MainListPageState();
}

class _MainListPageState extends State<MainListPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController _searchController;
  List<DocumentSnapshot> _filteredPosts = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xFFF6E690),
        title: Center(
          child: Text('스터디 그룹'),
        ),
        actions: [
          IconButton(
            icon: _isSearching ? Icon(Icons.cancel) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                if (!_isSearching) {
                  _isSearching = true;
                } else {
                  _isSearching = false;
                  _searchController.clear();
                  _filteredPosts.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainListPage()),
                  );
                }
              });
            },
          ),

        ],
      ),


      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_isSearching)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: '검색어를 입력하세요',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _performSearch();
                      },
                    ),
                  ),
                ),
              ),
            StreamBuilder(
              stream: _isSearching
                  ? FirebaseFirestore.instance.collection('posts').snapshots()
                  : FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var posts = snapshot.data!.docs;

                // _isSearching이 true일 때는 _filteredPosts를 사용하고, 그렇지 않으면 전체 포스트를 사용합니다.
                var displayPosts = _isSearching ? _filteredPosts : posts;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: displayPosts.length,
                  itemBuilder: (context, index) {
                    var post = displayPosts[index];
                    String userId = post['userId'];

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.done) {
                          String userNickname = userSnapshot.data!.get('userNickname') ?? '';

                          // startDate와 endDate의 Timestamp를 DateTime으로 변환
                          DateTime startDate = (post['startDate'] as Timestamp).toDate();
                          DateTime endDate = (post['endDate'] as Timestamp).toDate();

                          // DateFormat을 사용하여 날짜 포맷 지정
                          String formattedStartDate = DateFormat('yyyy.MM.dd').format(startDate);
                          String formattedEndDate = DateFormat('yyyy.MM.dd').format(endDate);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              surfaceTintColor: Colors.transparent,
                              color: Colors.white,
                              elevation: 3,
                              child: ListTile(
                                title: Text(
                                  post['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18, // 원하는 크기로 조절하세요.
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('리더: $userNickname'),
                                    Text('개발언어: ${post['language']}',
                                      style: TextStyle(
                                        color: Color(0xFFBE8A37),
                                        fontWeight: FontWeight.bold,
                                      ),),
                                    Text('시작일: $formattedStartDate'), // 포맷된 날짜 표시
                                    Text(
                                      '종료일: $formattedEndDate',
                                      style: TextStyle(
                                        color: Color(0xFFD56A6A),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    // 포맷된 날짜 표시

                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => InformationPage(
                                        title: post['title'],
                                        content: post['content'] ?? '',
                                        userNickname: userNickname,
                                        language: post['language'] ?? '',
                                        startDate: formattedStartDate, // 포맷된 날짜 표시
                                        endDate: formattedEndDate,     // 포맷된 날짜 표시
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
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WritePage()),
          );
        },
        backgroundColor: Color(0xFFFFC063), // 배경색을 흰색으로 설정
        child: Icon(
          Icons.add,
          color: Colors.white,// 아이콘 색상을 검정색으로 설정

        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // 원의 형태를 유지하도록 조절
          //side: BorderSide(color: Colors.white, width: 1.0),
        ),
      ),

      bottomNavigationBar: CustomBottomBar(
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

  void _performSearch() {
    String searchTerm = _searchController.text.toLowerCase();
    _filteredPosts.clear();

    FirebaseFirestore.instance.collection('posts').get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        String title = (doc['title'] ?? '').toLowerCase();
        String content = (doc['language'] ?? '').toLowerCase();
        if (title.contains(searchTerm) || content.contains(searchTerm)) {
          _filteredPosts.add(doc);
        }
      });

      setState(() {});
    });
  }
}