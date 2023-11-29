import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nicknameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController(text: widget.userData['userNickname'] ?? '');
    _emailController = TextEditingController(text: widget.userData['email'] ?? '');
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _updateUserInfo(String newNickname, String newEmail) async {
    try {
      DocumentReference userDocRef = FirebaseFirestore.instance.collection('users').doc(widget.userData['userId']);
      Map<String, dynamic> updatedData = {
        'userNickname': newNickname,
        'email': newEmail,
        // 다른 필드가 있다면 여기에 추가하세요.
      };
      await userDocRef.update(updatedData);
      print('사용자 정보가 업데이트되었습니다.');
    } catch (error) {
      print('사용자 정보 업데이트 중 에러 발생: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('내 정보 수정'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              controller: _nicknameController,
              decoration: InputDecoration(labelText: '닉네임'),
            ),
            SizedBox(height: 20.0),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                String newNickname = _nicknameController.text;
                String newEmail = _emailController.text;
                _updateUserInfo(newNickname, newEmail);
                Navigator.pop(context);
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
