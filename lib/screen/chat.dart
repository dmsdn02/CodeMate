import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class ChatMessage {
  final String message;
  final String time;
  final String senderId;
  final String senderNickname;
  final String roomId;

  ChatMessage({
    required this.message,
    required this.time,
    required this.senderId,
    required this.senderNickname,
    required this.roomId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'time': time,
      'senderId': senderId,
      'senderNickname': senderNickname,
      'roomId': roomId,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'],
      time: json['time'],
      senderId: json['senderId'],
      senderNickname: json['senderNickname'],
      roomId: json['roomId'],
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String title;
  final String userNickname;
  final String language;
  final String content;
  final String roomId;

  ChatScreen({
    required this.title,
    required this.userNickname,
    required this.language,
    required this.content,
    required this.roomId,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late IOWebSocketChannel _channel;
  late TextEditingController _controller;
  List<ChatMessage> _messages = [];
  late String currentUserID;
  String userNickname = '';

  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect('ws://192.168.56.1:8080');
    _controller = TextEditingController();
    _getCurrentUserID();
    _getUserNickname();
    _listenToMessages();
    WidgetsBinding.instance?.addObserver(this);

    _loadMessagesFromLocal();
  }

  void _loadMessagesFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedMessages = prefs.getStringList('chat_messages') ?? [];

    setState(() {
      _messages = savedMessages
          .map<ChatMessage>((message) => ChatMessage.fromJson(jsonDecode(message)))
          .toList();
    });
  }

  void _saveMessagesToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> messagesToSave = _messages.map((message) => jsonEncode(message.toJson())).toList();
    prefs.setStringList('chat_messages', messagesToSave);
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    _saveMessagesToLocal();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Load data or perform any action on resumed
    }
    super.didChangeAppLifecycleState(state);
  }

  void _getCurrentUserID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserID = user.uid;
    }
  }

  void _listenToMessages() {
    _channel.stream.listen((event) {
      String receivedMessage = event.toString();
      Map<String, dynamic> messageData = jsonDecode(receivedMessage);

      ChatMessage newMessage = ChatMessage(
        message: messageData['message'],
        time: messageData['time'],
        senderId: messageData['senderId'],
        senderNickname: messageData['senderNickname'],
        roomId: messageData['roomId'],
      );
      setState(() {
        _messages.add(newMessage);
      });
      _saveMessageToFirestore(newMessage);
    });
  }

  void _getUserNickname() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (snapshot.exists) {
        setState(() {
          userNickname = snapshot['nickname'];
        });
      }
    }
  }

  Widget _buildSenderMessage(ChatMessage message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            userNickname,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.yellow[100],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          message.message,
                          style: TextStyle(fontSize: 16),
                          softWrap: true,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          message.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReceiverMessage(ChatMessage message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            message.senderNickname,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.message,
                          style: TextStyle(fontSize: 16),
                          softWrap: true,
                          maxLines: null,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          message.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Color(0xFFF6E690),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (BuildContext context, int index) {
                int reversedIndex = _messages.length - index - 1;
                bool isMe = _messages[reversedIndex].senderId == currentUserID;

                return isMe
                    ? _buildSenderMessage(_messages[reversedIndex])
                    : _buildReceiverMessage(_messages[reversedIndex]);
              },
              reverse: true,
            ),
          ),
          Container(
            color: Color(0xFFF6E690),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter message',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _sendMessage();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
    );
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      String message = _controller.text;
      DateTime now = DateTime.now();
      String formattedTime = "${now.hour}:${now.minute}";

      ChatMessage newMessage = ChatMessage(
        message: message,
        time: formattedTime,
        senderId: currentUserID,
        senderNickname: 'Me',
        roomId: widget.roomId,
      );

      setState(() {
        _messages.add(newMessage);
      });

      _channel.sink.add(jsonEncode(newMessage.toJson()));
      _controller.clear();

      _saveMessageToFirestore(newMessage);
    }
  }

  void _saveMessageToFirestore(ChatMessage message) async {
    try {
      await FirebaseFirestore.instance.collection('messages').add(message.toJson());
    } catch (e) {
      print('Error saving message: $e');
    }
  }
}
