import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:web_socket_channel/io.dart';

class ChatScreen extends StatefulWidget {
  final String title;
  final String userNickname;
  final String language;
  final String content;

  ChatScreen({
    required this.title,
    required this.userNickname,
    required this.language,
    required this.content,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver {
  late IOWebSocketChannel _channel;
  late TextEditingController _controller;
  List<Map<String, dynamic>> _messages = [];


  @override
  void initState() {
    super.initState();
    _channel = IOWebSocketChannel.connect('ws://192.168.56.1:8080');
    _controller = TextEditingController();
    _loadMessages();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadMessages();
    }
    super.didChangeAppLifecycleState(state);
  }

  void _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? messagesJson = prefs.getStringList(widget.content); // 수정된 부분
    if (messagesJson != null) {
      setState(() {
        _messages = messagesJson.map((json) => jsonDecode(json)).toList().cast<Map<String, dynamic>>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅'),
        backgroundColor: Color(0xFFF6E690),
        actions: [
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
                bool isMe = _messages[reversedIndex]['senderId'] == '내 계정 ID'; // 발신자 ID 비교

                return Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            isMe ? '나' : _messages[reversedIndex]['nickname'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMe ? Colors.black : Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isMe ? Colors.yellow[100] : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _messages[reversedIndex]['message'],
                                      style: TextStyle(fontSize: 16),
                                      softWrap: true,
                                      maxLines: null,
                                      overflow: TextOverflow.visible,
                                    ),
                                    Text(
                                      _messages[reversedIndex]['time'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      textAlign: isMe ? TextAlign.end : TextAlign.start,
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
                        hintText: '메시지를 입력하세요',
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
      Map<String, dynamic> newMessage = {
        'message': message,
        'time': formattedTime,
        'isMe': true,
        'nickname': '나',
      };
      setState(() {
        _messages.add(newMessage);
      });
      _saveMessages();
      _channel.sink.add(message);
      _controller.clear();
    }
  }

  void _saveMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> messagesJson = _messages.map((message) => jsonEncode(message)).toList();
    await prefs.setStringList(widget.content, messagesJson); // 수정된 부분
  }
}
