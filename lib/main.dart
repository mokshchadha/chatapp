import 'package:chatapp/screens/auth_screen.dart';
import 'package:chatapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Moksh\'s chatapp',
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          backgroundColor: Colors.blueAccent,
          accentColor: Colors.deepPurple,
          buttonTheme: ButtonTheme.of(context).copyWith(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              buttonColor: Colors.lightBlueAccent,
              textTheme: ButtonTextTheme.primary),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, userSnapShot) {
            if (userSnapShot.hasData) {
              return ChatScreen();
            }
            return AuthScreen();
          },
        ));
  }
}
