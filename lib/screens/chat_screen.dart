import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('chats/NKzfPhCDjLVgVEfhnlpL/messages')
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            dynamic data = snapshot.requireData;
            return ListView.builder(
              itemBuilder: (ctx, idx) {
                dynamic messageTxt = data.docs[idx].data()['text'];
                print(data.docs[idx].data());
                return Container(
                  padding: const EdgeInsets.all(8),
                  child: Text(messageTxt.toString()),
                );
              },
              itemCount: data.size ?? 0,
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/NKzfPhCDjLVgVEfhnlpL/messages')
              .add({'text': 'Dummy message XX'});
        },
      ),
    );
  }
}
