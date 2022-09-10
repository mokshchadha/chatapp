import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String messageText;
  final Timestamp timestamp;
  final String sender;

  final Key key;

  MessageBubble(this.messageText, this.timestamp, this.sender,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        width: 250,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: sender == FirebaseAuth.instance.currentUser?.email
                ? const Color.fromRGBO(0, 181, 226, 0.4)
                : const Color.fromRGBO(200, 200, 200, 0.4),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sender,
                  style: const TextStyle(fontSize: 7, color: Colors.blueGrey),
                ),
                Text(messageText, style: const TextStyle(color: Colors.black)),
              ],
            ),
            Text(
              DateFormat('kk:mm dd-MM-yyyy').format(timestamp.toDate()),
              style: const TextStyle(fontSize: 8, color: Colors.grey),
            )
          ],
        ),
      ),
    ]);
  }
}
