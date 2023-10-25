// ignore_for_file: prefer_const_constructors

import 'package:ilkvisual/model/user.dart';
import 'package:ilkvisual/services/auth_base.dart';

class FakeAuthService implements AuthBase {
  String userID = "asdasdasdas";

  @override
  Future<User1?> currentUser1() async {
    return await Future.value(User1(userID: "currenttttt y", email: userID));
  }

  @override
  Future<User1?> signInAnonymously1() async {
    return await Future.delayed(
        Duration(seconds: 2), (() => User1(userID: userID, email: userID)));
  }

  @override
  Future<bool> signOut1() {
    return Future.value(true);
  }

  @override
  Future<User1> sigInWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<User1?> sigInWithFacebook() {
    // ignore: todo
    // TODO: implement sigInWithFacebook
    throw UnimplementedError();
  }

  @override
  Future<User1?> createUserWithEmailandPassword(String email, String sifre) {
    throw UnimplementedError();
  }

  @override
  Future<User1?> sigInWithEmailandPassword(String email, String sifre) {
    throw UnimplementedError();
  }
}
