import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:touroll/screens/login.dart';
import 'package:touroll/services/auth.dart';

class LoginOnly extends StatefulWidget {
  final WidgetBuilder builder;
  final WidgetBuilder anonymousBuilder;
  LoginOnly({Key key, this.builder, this.anonymousBuilder}) : super(key: key);

  @override
  _LoginOnlyState createState() => _LoginOnlyState();
}

class _LoginOnlyState extends State<LoginOnly> {
  AuthService authService = AuthService();
  StreamSubscription streamSub;

  @override
  void initState() {
    super.initState();
    if (widget.anonymousBuilder == null)
      streamSub = FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user == null) {
          streamSub.cancel();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => LoginScreen()));
        }
      });
  }

  @override
  void dispose() {
    if (streamSub != null) streamSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser == null) {
      if (widget.anonymousBuilder != null)
        return widget.anonymousBuilder(context);
      return Container();
    }
    return widget.builder(context);
  }
}
