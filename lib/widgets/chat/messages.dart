import 'package:chatapp/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LinearProgressIndicator();
          }
          dynamic data = snapshot.requireData;
          return ListView.builder(
            reverse: true,
            itemBuilder: (ctx, idx) {
              dynamic messageText = data.docs[idx].get('text');
              dynamic createdAt = data.docs[idx].get('createdAt');
              dynamic sender = data.docs[idx].get('userId');
              dynamic imageUrl = data.docs[idx].get('imageUrl');

              dynamic key =
                  ValueKey(data.docs[idx].reference.id); //to make it optimal

              final user = FirebaseAuth.instance.currentUser;
              return Row(
                mainAxisAlignment: user?.email == sender
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: [
                  MessageBubble(messageText, createdAt, sender, imageUrl,
                      key: key)
                ],
              );
            },
            itemCount: data.size ?? 0,
          );
        });
  }
}
