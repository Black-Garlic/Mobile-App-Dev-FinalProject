import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseState extends ChangeNotifier {
  late UserCredential _user;
  UserCredential get user => _user;

  FirebaseState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp();

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {

      }
      notifyListeners();
    });
  }

  Future<bool> signInWithGoogle(context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    notifyListeners();

    _user = await FirebaseAuth.instance.signInWithCredential(credential);
    return checkNewUser();
  }

  Future<bool> checkNewUser() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo:FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (final document in _myDoc.docs) {
      return false;
    }
    return true;
  }

  void addNewUser() async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection('user')
        .where('uid', isEqualTo:FirebaseAuth.instance.currentUser!.uid)
        .get();

    for (final document in _myDoc.docs) {
      return;
    }
    FirebaseFirestore.instance
        .collection('user')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'email': FirebaseAuth.instance.currentUser!.email,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'nickname': FirebaseAuth.instance.currentUser!.displayName,
      'reg_date': FieldValue.serverTimestamp(),
      'mod_date': FieldValue.serverTimestamp(),
    });
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}