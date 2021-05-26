import 'package:firebase_auth/firebase_auth.dart';
import 'package:touroll/models/tokens.dart';
import 'package:touroll/models/user.dart';
import 'package:touroll/utils/http.dart';
import 'package:touroll/utils/storage.dart';

class AuthService {
  String getUid() {
    try {
      return FirebaseAuth.instance.currentUser?.uid;
    } catch (ex) {
      return null;
    }
  }

  bool isLoggedIn() {
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      return false;
    } else {
      return true;
    }
  }

  void signIn(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user.');
      }
    }
  }

  void register(email, password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw new Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw new Exception('The account already exists for that email.');
      }
    } catch (e) {
      throw new Exception(e);
    }
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
