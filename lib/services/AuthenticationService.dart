import 'package:cake_mania/Services/FirestoreDatabase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LocalUser {
  String uid;
  String displayName;
  String displayImage;
  String email;
  bool? emailVerified;
  LocalUser({
    required this.uid,
    required this.displayName,
    required this.displayImage,
    required this.email,
    this.emailVerified,
  });
  factory LocalUser.fromJson(json) => LocalUser(
        uid: json["uid"],
        displayName: json["displayName"],
        displayImage: json["displayImage"],
        email: json["email"],
        emailVerified: json["emailVerified"],
      );

  static Map<String, dynamic> toJson(LocalUser user) => {
        "uid": user.uid,
        "displayName": user.displayName,
        "displayImage": user.displayImage,
        "email": user.email,
        "emailVerified": user.emailVerified,
      };
}

abstract class AuthBase {
  Stream<LocalUser?> authStateChange();
  Future<void> signOut();
  Future<LocalUser?> signInWithGoogle();
}

class Auth implements AuthBase {
  final _firebaseInstance = FirebaseAuth.instance;
  final Database _database = MyFirestoreDatabse();
  GoogleSignIn _googleSignIn = GoogleSignIn();

  LocalUser? _userFromFirebase(User? _user) {
    if (_user != null) {
      return LocalUser(
        uid: _user.uid,
        displayImage: _user.photoURL!,
        displayName: _user.displayName!,
        email: _user.email!,
        emailVerified: _user.emailVerified,
      );
    } else
      return null;
  }

  @override
  Stream<LocalUser?> authStateChange() {
    final authResult = _firebaseInstance.authStateChanges();
    return authResult.map((event) => _userFromFirebase(event));
  }

  @override
  Future<void> signOut() async {
    await _firebaseInstance.signOut();
    await _googleSignIn.signOut();
  }

  Future<LocalUser?> signInWithGoogle() async {
    GoogleSignInAccount? googleAccount;
    googleAccount = await _googleSignIn.signIn();
    if (googleAccount != null) {
      GoogleSignInAuthentication googleAuth =
          await googleAccount.authentication;
      final authResult = await _firebaseInstance.signInWithCredential(
        GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        ),
      );
      if (authResult.additionalUserInfo!.isNewUser) {
        _database.createNewUser(_userFromFirebase(authResult.user)!);
      }
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: 'SIGN_IN_ABORTED',
        message: 'User did not signed in',
      );
    }

    // @override
    // Future<LocalUser?> signInAnonymously() async {
    //   final authResult = await _firebaseInstance.signInAnonymously();
    //   await _database.setUser(authResult.user!.uid, jsonData(null));
    //   return _userFromFirebase(authResult.user);
    // }

    // Future<LocalUser?> registerWithEmailPassword(
    //     {required String email,
    //     required String password,
    //     required String name}) async {
    //   final authResult = await _firebaseInstance.createUserWithEmailAndPassword(
    //       email: email, password: password);
    //   await _database.setUser(authResult.user!.uid, jsonData(name));
    //   return _userFromFirebase(authResult.user);
    // }

    // Future<LocalUser?> signInWithEmailPassword(
    //     {required String email, required String password}) async {
    //   final authResult = await _firebaseInstance.signInWithEmailAndPassword(
    //       email: email, password: password);
    //   return _userFromFirebase(authResult.user);
    // }
  }
}
