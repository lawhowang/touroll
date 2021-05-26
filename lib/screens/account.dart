import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:touroll/screens/login.dart';
import 'package:touroll/screens/me/my_reservation.dart';
import 'package:touroll/screens/me/my_tours.dart';
import 'package:touroll/screens/profile.dart';
import 'package:touroll/services/auth.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({Key key}) : super(key: key);

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  AuthService authService = AuthService();
  bool loggedIn = false;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null) {
        setState(() {
          loggedIn = true;
        });
      } else {
        setState(() {
          loggedIn = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        child: ListView(
          children: [
            ListTile(
              title: Text(loggedIn ? 'Account' : 'Sign In'),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()))
              },
            ),
            ListTile(
              title: Text('Tours'),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyToursScreen()))
              },
            )
          ],
        ),
      ),
    );
  }
}
