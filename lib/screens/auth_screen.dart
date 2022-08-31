import 'package:chatapp/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool isLoading = false;

  void submitAuthForm({
    required String email,
    required String userName,
    required String password,
    required bool isLogin,
    required BuildContext ctx,
  }) async {
    try {
      try {
        UserCredential authResult;
        setState(() {
          isLoading = true;
        });
        if (isLogin) {
          authResult = await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          setState(() {
            isLoading = false;
          });
          return;
        }
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'userName': userName,
          'email': email,
        });
        setState(() {
          isLoading = false;
        });
        return;
      } on PlatformException catch (e) {
        var message =
            'An error ocuured in firebase auth, please check credentials';
        print(message);
        if (e.message != null) message = e.message!;

        Scaffold.of(ctx).showSnackBar(SnackBar(
            content: Text(message),
            backgroundColor: Theme.of(context).errorColor));
      }
    } catch (e) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
          content: Text(e.toString()),
          backgroundColor: Theme.of(context).errorColor));
      print(e);
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(submitAuthForm, isLoading));
  }
}
