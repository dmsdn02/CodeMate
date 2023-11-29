import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'MyPage.dart';
import 'appbar.dart';
import 'mainlist.dart';
import 'chat.dart';

class ChatList extends StatefulWidget {
  final String userId;

  const ChatList({Key? key, required this.userId}) : super(key: key);

  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  late Future<List<ChatRoomInfo>> chatRooms;

  @override
  void initState() {
    super.initState();
    chatRooms = getChatRooms();
  }

  Future<List<ChatRoomInfo>> getChatRooms() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('chatrooms')
        .where('participants', arrayContains: widget.userId)
        .get();

    List<ChatRoomInfo> roomList = [];
    Set<String> uniqueRoomIds = Set();

    querySnapshot.docs.forEach((doc) {
      String roomId = doc.id;
      String title = doc['title'];
      String language = doc['language'];
      String creator = doc['userNickname'];

      if (!uniqueRoomIds.contains(roomId)) {
        uniqueRoomIds.add(roomId);
        roomList.add(ChatRoomInfo(
          title: title,
          language: language,
          creator: creator,
          roomId: roomId,
        ));
      }
    });

    return roomList;
  }

  void navigateToChatRoom(ChatRoomInfo chatRoom) {
    FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoom.roomId)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> roomData = snapshot.data() as Map<String, dynamic>;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              title: roomData['title'],
              userNickname: roomData['userNickname'],
              language: roomData['language'],
              content: '', // content는 ChatScreen에서 사용되지 않는다면 비워도 됩니다.
              roomId: chatRoom.roomId,
            ),
          ),
        );
      } else {
        print('Room not found');
        // 여기에 채팅방을 찾을 수 없는 경우 처리할 로직 추가
      }
    }).catchError((error) {
      print('Error getting room: $error');
      // 에러 처리 로직 추가
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(title: '채팅 목록'),
      body: FutureBuilder<List<ChatRoomInfo>>(
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
              itemCount: snapshot.data!.length * 2 - 1,
              itemBuilder: (context, index) {
                if (index.isOdd) {
                  return Divider(
                    color: Colors.grey[300],
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                  );
                }

                final roomIndex = index ~/ 2;
                String languageStudy = '${snapshot.data![roomIndex].language} 공부 시작한 지 5일차 ';

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: GestureDetector(
                    onTap: () {
                      navigateToChatRoom(snapshot.data![roomIndex]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: Icon(Icons.collections_bookmark_outlined, size: 42, color: Colors.black),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  snapshot.data![roomIndex].title,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '리더: ${snapshot.data![roomIndex].creator}',
                                  style: TextStyle( fontSize: 14, color: Colors.black),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  languageStudy,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
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
}

class ChatRoomInfo {
  final String title;
  final String language;
  final String creator;
  final String roomId;

  ChatRoomInfo({required this.title, required this.language, required this.creator, required this.roomId});
}
