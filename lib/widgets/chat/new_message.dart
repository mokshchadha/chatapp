import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  dynamic _enteredValue = '';
  final _controller = TextEditingController();
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;

    final imageUrl = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot doc) {
      final data = doc.data() as Map<String, dynamic>;
      return data['image'];
    });

    print(imageUrl);

    FirebaseFirestore.instance.collection('chat').add({
      'text': _enteredValue,
      'createdAt': Timestamp.now(),
      'userId': user?.email,
      'imageUrl': imageUrl
    });
    _controller.clear();
    setState(() {
      _enteredValue = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        Expanded(
            child: TextField(
          controller: _controller,
          decoration: const InputDecoration(labelText: 'Send a message'),
          onChanged: (value) {
            setState(() {
              _enteredValue = value;
            });
          },
        )),
        IconButton(
          onPressed: _enteredValue.trim().isEmpty ? null : _sendMessage,
          icon: const Icon(Icons.send),
          color: Colors.lightBlue,
        )
      ]),
    );
  }
}
