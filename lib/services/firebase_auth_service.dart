// ignore_for_file: unused_element, curly_braces_in_flow_control_structures, unnecessary_null_comparison, await_only_futures, prefer_interpolation_to_compose_strings, avoid_print, body_might_complete_normally_nullable, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers, unused_import

import 'package:ilkvisual/locator.dart';
import 'package:ilkvisual/model/user.dart';
import 'package:ilkvisual/services/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FirebaseAuthService implements AuthBase {
  final FirebaseAuth _fireBaseAuth = FirebaseAuth.instance;

  @override
  Future<User1?> currentUser1() async {
    try {
      User? user = await _fireBaseAuth.currentUser;
      return _userFromFirebase(user);
    } catch (e) {
      print("HATAAA!!!!!!!!!! currunt user" + e.toString());
      return null;
    }
  }

  User1? _userFromFirebase(User? user) {
    if (user == null) return null;
    print(user.uid + "buraaaaaaAAAAAAAAAAAAAAAAABURAAAA");
    return User1(userID: user.uid, email: user.email);
  }

  @override
  Future<User1?> signInAnonymously1() async {
    try {
      UserCredential sonuc = await _fireBaseAuth.signInAnonymously();
      return _userFromFirebase(sonuc.user);
    } catch (e) {
      print("HATAAA!!!!!!!!!!   Anonim hata girişi" + e.toString());
      return null;
    }
  }

  @override
  Future<bool> signOut1() async {
    try {
      final _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      await _fireBaseAuth.signOut();
      return true;
    } catch (e) {
      print("HATAAA!!!!!!!!!!HATAAA!!!!!!!!!!HATAAA!!!!!!!!!!HATAAA!!!!!!!!!!" +
          e.toString());
      return false;
    }
  }

  @override
  Future<User1?> sigInWithGoogle() async {
    GoogleSignIn _googSignIn = GoogleSignIn();
    GoogleSignInAccount? _googleUser = await _googSignIn.signIn();
    if (_googleUser != null) {
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      if (_googleAuth.idToken != null && _googleAuth.accessToken != null) {
        UserCredential sonuc = await _fireBaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: _googleAuth.idToken,
                accessToken: _googleAuth.accessToken));
        User? _user = sonuc.user;
        return _userFromFirebase(_user);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<User1?> sigInWithFacebook() async {
    final _facebookLogin = FacebookAuth.i;
    LoginResult _faceResult =
        await _facebookLogin.login(permissions: ['public_profile', 'email']);

    switch (_faceResult.status) {
      case LoginStatus.success:
        if (_faceResult.accessToken != null) {
          UserCredential _firebaseResult = await _fireBaseAuth
              .signInWithCredential(FacebookAuthProvider.credential(
                  _faceResult.accessToken!.token));
          User? _user = _firebaseResult.user;
          return _userFromFirebase(_user);
        }
        break;
      case LoginStatus.failed:
        print("hataa  FACEEE HATAAAAAAAAAAAAAAAAAAA" +
            _faceResult.message.toString());
        break;
      case LoginStatus.cancelled:
        print("FACE GİRİSİ İPTAL ETTİ AMCIK");
        break;
      default:
    }
    return null;
  }

  @override
  Future<User1?> createUserWithEmailandPassword(
      String email, String sifre) async {
    UserCredential sonuc = await _fireBaseAuth.createUserWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }

  @override
  Future<User1?> sigInWithEmailandPassword(String email, String sifre) async {
    UserCredential sonuc = await _fireBaseAuth.signInWithEmailAndPassword(
        email: email, password: sifre);
    return _userFromFirebase(sonuc.user);
  }
}
