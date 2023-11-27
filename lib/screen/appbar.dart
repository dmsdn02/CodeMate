import 'package:code_mate/screen/mainlist.dart';
import 'package:flutter/material.dart';
import 'ChatList.dart';
import 'MyPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Color(0xFFF6E690),
      title: Text(title),
    );
  }
}

class CustomBottomBar extends StatelessWidget {
  final Function() onMyPagePressed;
  final Function() onMainPagePressed;
  final Function() onChatPressed;

  const CustomBottomBar({
    Key? key,
    required this.onMyPagePressed,
    required this.onMainPagePressed,
    required this.onChatPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      surfaceTintColor: Colors.transparent,
      color: Color(0xFFF6E690),
      shape: CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: onMyPagePressed,
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: onMainPagePressed,
          ),
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: onChatPressed,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MyNavigationApp(),
  ));
}

class MyNavigationApp extends StatefulWidget {
  @override
  _MyNavigationAppState createState() => _MyNavigationAppState();
}

class _MyNavigationAppState extends State<MyNavigationApp> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    MainListPage(),
    MyPage(),
    ChatList(userId: '사용자 아이디 값')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'My App'),
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: CustomBottomBar(
        onMyPagePressed: () {
          setState(() {
            _currentIndex = 1;
          });
        },
        onMainPagePressed: () {
          setState(() {
            _currentIndex = 0;
          });
        },
        onChatPressed: () {
          setState(() {
            _currentIndex = 2;
          });
        },
      ),
    );
  }
}
