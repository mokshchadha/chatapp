import 'dart:io';

import 'package:chatapp/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
      {required String email,
      required String password,
      required String userName,
      required bool isLogin,
      required File image,
      required BuildContext ctx}) submitAuthForm;

  bool isLoading = false;

  AuthForm(this.submitAuthForm, this.isLoading);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  late File _userImageFile;

  bool _isLogin = false;

  void _setPickedImage(File image) {
    _userImageFile = image;
  }

  void _submit() {
    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text('Please pick an image ')));
      return;
    }
    final isValid = _formKey.currentState != null
        ? _formKey.currentState?.validate()
        : false;

    FocusScope.of(context).unfocus();
    if (isValid as bool) {
      _formKey.currentState?.save();
      widget.submitAuthForm(
          password: _userPassword.trim(),
          email: _userEmail.trim(),
          userName: _userName.trim(),
          image: _userImageFile,
          isLogin: _isLogin,
          ctx: context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  UserImagePicker(_setPickedImage),
                  TextFormField(
                    key: const ValueKey('email'),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !value.contains('@')) {
                        return 'Please add a valid email address';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        const InputDecoration(labelText: 'Email Address'),
                    onChanged: (value) {
                      _userEmail = value;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('userName'),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 4) {
                          return 'Username should atleast be 4 chars long';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(labelText: 'UserName'),
                      onChanged: (value) {
                        _userName = value;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    validator: (value) {
                      if (value == null || value.length < 7) {
                        return 'Password must be atleast 7 characters long.';
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: const InputDecoration(labelText: 'Password'),
                    onChanged: (value) {
                      _userPassword = value;
                    },
                  ),
                  const SizedBox(height: 15),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    ElevatedButton(
                        onPressed: _submit,
                        child: Text(
                          _isLogin ? 'Login' : 'Sign Up',
                          style: const TextStyle(color: Colors.white),
                        )),
                  if (!widget.isLoading)
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create New Account'
                            : 'I already have an account'))
                ],
              )),
        ),
      ),
    ));
  }
}
