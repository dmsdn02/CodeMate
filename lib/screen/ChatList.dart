import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MyPage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'appbar.dart';
import 'mainlist.dart';

class ChatList extends StatefulWidget {
  final String userId; // 사용자 ID를 받아옵니다.

  const ChatList({Key? key, required this.userId}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late Future<List<String>> chatRooms; // 사용자의 채팅방 목록을 가져올 Future

  @override
  void initState() {
    super.initState();
    // initState에서 사용자의 채팅방 목록을 가져오는 함수를 호출합니다.
    chatRooms = getChatRooms();
  }

  Future<List<String>> getChatRooms() async {
    // Firestore에서 사용자가 참여한 채팅방 목록을 가져오는 함수를 구현합니다.
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chatRooms')
        .where('participants', arrayContains: widget.userId)
        .get();

    List<String> roomList = [];
    querySnapshot.docs.forEach((doc) {
      roomList.add(doc.id);
    });

    return roomList;
  }

  void navigateToChatRoom(String roomId) {
    // 선택한 채팅방으로 이동하는 로직을 여기에 추가하세요.
    // roomId를 사용하여 채팅방으로 이동하는 코드를 작성합니다.
    // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomScreen(roomId: roomId)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Chat Rooms'), // 여기에 CustomAppBar 추가
      body: FutureBuilder<List<String>>(
        future: chatRooms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No chat rooms available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index]),
                  onTap: () {
                    navigateToChatRoom(snapshot.data![index]);
                  },
                );
              },
            );
          }
        },
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
