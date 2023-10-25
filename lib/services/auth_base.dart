import 'package:ilkvisual/model/user.dart';

abstract class AuthBase {
  Future<User1?> currentUser1();
  Future<User1?> signInAnonymously1();
  Future<bool> signOut1();
  Future<User1?> sigInWithGoogle();
  Future<User1?> sigInWithFacebook();
  Future<User1?> sigInWithEmailandPassword(String email, String sifre);
  Future<User1?> createUserWithEmailandPassword(String email, String sifre);
}
