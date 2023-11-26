import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:code_mate/main.dart';

void main() {
  runApp(MyApp());
}

class ChatScreen extends StatefulWidget {
  final IOWebSocketChannel? channel;

  ChatScreen({Key? key, this.channel}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late IOWebSocketChannel _channel;
  late TextEditingController _controller;
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _channel = widget.channel ?? IOWebSocketChannel.connect('ws://192.168.219.153:8080');
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _channel.sink.close();
    _controller.dispose();
    super.dispose();
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
                return Column(
                  crossAxisAlignment: _messages[reversedIndex]['isMe']
                      ? CrossAxisAlignment.end // 보내는 사람의 메시지는 오른쪽 정렬
                      : CrossAxisAlignment.start, // 받는 사람의 메시지는 왼쪽 정렬
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        crossAxisAlignment: _messages[reversedIndex]['isMe']
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            _messages[reversedIndex]['nickname'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _messages[reversedIndex]['isMe']
                                  ? Colors.black
                                  : Colors.white,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: _messages[reversedIndex]['isMe']
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _messages[reversedIndex]['isMe']
                                      ? Colors.yellow[100]
                                      : Colors.grey[300],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: _messages[reversedIndex]['isMe']
                                      ? CrossAxisAlignment.end
                                      : CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _messages[reversedIndex]['message'],
                                      style: TextStyle(fontSize: 16),
                                      softWrap: true, // 줄 바꿈 허용
                                      maxLines: null, // 최대 줄 수 없음
                                      overflow: TextOverflow.visible, // 내용이 넘칠 경우 가리지 않고 보여줌
                                    ),
                                    Text(
                                      _messages[reversedIndex]['time'],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                      textAlign: _messages[reversedIndex]['isMe']
                                          ? TextAlign.end
                                          : TextAlign.start,
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
        'isMe': true, // 보내는 사람 여부
        'nickname': '나', // 닉네임(변경 가능)
      };
      setState(() {
        _messages.add(newMessage);
      });
      _channel.sink.add(message);
      _controller.clear();
    }
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}
