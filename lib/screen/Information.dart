import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat.dart';
import 'ChatList.dart'; // ChatList import 추가

class InformationPage extends StatelessWidget {
  final String title;
  final String userNickname;
  final String language;
  final String content;
  final String startDate; // startDate 추가
  final String endDate;   // endDate 추가

  InformationPage({
    required this.title,
    required this.userNickname,
    required this.language,
    required this.content,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상세정보'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFF6E690), // 배경색 변경
        ),
        child: Center(
          child: SizedBox(
            width: 370, // 카드의 가로 길이 지정
            height: 520, // 카드의 세로 길이 지정
            child: Card(
              surfaceTintColor: Colors.transparent,
              margin: EdgeInsets.only(top: 1),
              elevation: 5,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '방의 상세정보를 확인해주세요!',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    Text(
                      '$title',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '작성자:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '$userNickname',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '공부언어:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '$language',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '공부 시작 날짜:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '$startDate',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '공부 끝나는 날짜:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '$endDate',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    Text(
                      '상세내용:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '$content',
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 16, right: 63),
        child: ElevatedButton(
          onPressed: () => _enterChatRoom(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 45),
            child: Text('채팅방 입장', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          style: ElevatedButton.styleFrom(
            primary: Colors.brown[300], // 버튼 배경색 변경
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18), // 버튼 모양 변경
            ),
            elevation: 5,
          ),
        ),
      ),
    );
  }

  void _enterChatRoom(BuildContext context) async {
    try {
      bool isAlreadyJoined = await _checkIfAlreadyJoined(
          FirebaseAuth.instance.currentUser!.uid, title);

      if (isAlreadyJoined) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              surfaceTintColor: Colors.transparent,
              backgroundColor: Colors.white,
              title: Text('이미 참여한 채팅방입니다.'),
              actions: <Widget>[
                TextButton(
                  child: Text('채팅 목록으로 이동'),
                  onPressed: () {
                    _enterChatList(context); // 수정된 부분
                  },
                ),
              ],
            );
          },
        );
      } else {
        DocumentReference docRef = await FirebaseFirestore.instance.collection(
            'chatrooms').add({
          'userId': FirebaseAuth.instance.currentUser!.uid,
          'title': title,
          'userNickname': userNickname,
          'language': language,
          'content': content,
          'timestamp': FieldValue.serverTimestamp(),
          'participants': [FirebaseAuth.instance.currentUser!.uid],
        });

        String roomId = docRef.id;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ChatScreen(
                  title: title,
                  userNickname: userNickname,
                  language: language,
                  content: content,
                  roomId: roomId,
                ),
          ),
        );
      }
    } catch (e) {
      print('Error entering chat room: $e');
    }
  }

  void _enterChatList(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatList(userId: FirebaseAuth.instance.currentUser!.uid)), // 수정된 부분
    );
  }

  Future<bool> _checkIfAlreadyJoined(String userId, String title) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('userId', isEqualTo: userId)
        .where('title', isEqualTo: title)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }
}
