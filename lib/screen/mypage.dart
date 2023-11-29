import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:code_mate/screen/mainlist.dart';
import 'package:code_mate/screen/appbar.dart';
//import 'package:url_launcher/url_launcher.dart';
import 'ChatList.dart';
import 'calendarpage.dart';
import 'login.dart';

void main() {
  runApp(MaterialApp(
    home: MyPage(),
  ));
}

class MyPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

// 초대 버튼 다이얼로그 표시 함수
  void showInviteDialog(BuildContext context, String inviteLink) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("초대"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("친구에게 아래 링크를 공유하세요:"),
              SizedBox(height: 10),
              SelectableText(inviteLink),
            ],
          ),
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
  // 초대 링크 생성 함수
  // 정적 초대 링크 생성 함수
  String generateInviteLink() {
    // 예시: 앱 다운로드 페이지 URL
    String inviteLink = 'https://example.com/myapp';
    return inviteLink;
  }



  //DB로그아웃 함수
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      print('로그아웃 성공'); // 추가
    } catch (e) {
      print('로그아웃 중 오류 발생: $e');
    }
  }

  //DB사용자데이터 삭제함수
  Future<void> deleteUserAccount() async {
    try {
      String userId = _auth.currentUser!.uid;

      // 사용자가 작성한 모든 글 가져오기
      QuerySnapshot postsSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .get();

      // 가져온 글을 삭제
      for (QueryDocumentSnapshot post in postsSnapshot.docs) {
        await FirebaseFirestore.instance.collection('posts')
            .doc(post.id)
            .delete();
      }

      // Firestore에서 사용자 데이터 삭제
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

      // Firebase Authentication에서 사용자 삭제
      await _auth.currentUser!.delete();

      // 로그아웃
      await _auth.signOut();
      print('회원 탈퇴 성공');
    } catch (e) {
      print('회원 탈퇴 중 오류 발생: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: '마이페이지'),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(
              _auth.currentUser!.uid).get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || !snapshot.data!.exists) {
                return Text('No Data Found');
              } else {
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                String userNickname = userData['userNickname'] ??
                    'No UserNickname';
                String email = userData['email'] ?? 'No Email';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      // Card를 코드로 구현
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '내 정보',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  // TODO: 내 정보 수정 기능 구현
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          ListTile(
                            leading: const CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(
                                  'https://via.placeholder.com/150'),
                            ),
                            title: Text(
                              '$userNickname',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '$email',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  print('초대 버튼이 탭되었습니다.');

                                  // 초대 링크 생성
                                  final inviteLink = generateInviteLink();

                                  // 다이얼로그 표시
                                  showInviteDialog(context, inviteLink);
                                },
                                child: Column(
                                  children: <Widget>[
                                    Icon(Icons.person_outline),
                                    SizedBox(height: 5),
                                    Text(
                                      '초대',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) => CalendarPage(),
                                      );
                                    },
                                    child: Column(
                                      children: <Widget>[
                                        Icon(Icons.calendar_today_outlined),
                                        SizedBox(height: 5),
                                        Text(
                                          '일정',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Icon(Icons.history),
                                  SizedBox(height: 5),
                                  Text(
                                    '기록',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              LogoutDialog(signOutCallback: signOut),
                        );
                      },
                      child: ListTile(
                        leading: Icon(Icons.exit_to_app),
                        title: Text(
                          '로그아웃',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              DeleteAccountDialog(
                                  deleteAccountCallback: deleteUserAccount),
                        );
                      },
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title: Text(
                          '회원 탈퇴',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      '추가 설정',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.language),
                      title: Text('언어 설정'),
                      onTap: () {
                        // TODO: 언어 설정 기능 구현
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.notifications),
                      title: Text('알림 설정'),
                      onTap: () {
                        // TODO: 알림 설정 기능 구현
                      },
                    ),
                  ],
                );
              }
            }
          },
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
          User? user = _auth.currentUser;

          if (user != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ChatList(userId: user.uid)),
            );
          }
        },
      ),
    );
  }

}

class LogoutDialog extends StatelessWidget {
  final VoidCallback signOutCallback;

  LogoutDialog({required this.signOutCallback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("로그아웃"),
      content: Text("로그아웃 하시겠습니까?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("취소"),
        ),
        TextButton(
          onPressed: () {
            // 확인 버튼을 누르면 signOutCallback을 호출하여 로그아웃 수행
            signOutCallback();
            print('로그아웃 다이얼로그 확인 버튼 눌림');  // 추가
            Navigator.pop(context);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text("확인"),
        ),

      ],
    );
  }
}

class DeleteAccountDialog extends StatelessWidget {
  final VoidCallback deleteAccountCallback;

  DeleteAccountDialog({required this.deleteAccountCallback});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("회원 탈퇴"),
      content: Text("정말 탈퇴 하시겠습니까?"),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("취소"),
        ),
        TextButton(
          onPressed: () async {
            // 확인 버튼을 누르면 deleteAccountCallback을 호출하여 회원 탈퇴 수행
            deleteAccountCallback();
            print('회원 탈퇴 다이얼로그 확인 버튼 눌림');  // 추가
            Navigator.pop(context);

            // 회원 탈퇴 후 로그인 페이지로 이동
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
          child: Text("확인"),
        ),
      ],
    );
  }
}
