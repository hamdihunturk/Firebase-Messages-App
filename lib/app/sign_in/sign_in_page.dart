// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers, unused_element, avoid_print

import 'package:flutter/material.dart';
import 'package:ilkvisual/app/sign_in/email_sif_giris_kayit.dart';
import '../../common_widget/social_log_in_button.dart';
import '../../model/user.dart';
import '../../viewmodels/usermodel.dart';
import 'package:provider/provider.dart';

// ignore: use_key_in_widget_constructors
class SignInpage extends StatelessWidget {
  void _misafirGirisi(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context,
        listen:
            false); // BUTON İÇİ LİSTENER FALSE YAPILIR NEDENİ METOD CAGİRMA İSLEMLERİ CART CURT
    User1? _sonuc = await _usermodel.signInAnonymously1();

    print("oturum açan user id:" + _sonuc!.userID.toString());
  }

  void _googleIleGiris(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context,
        listen:
            false); // BUTON İÇİ LİSTENER FALSE YAPILIR NEDENİ METOD CAGİRMA İSLEMLERİ CART CURT
    User1? _sonuc = await _usermodel.sigInWithGoogle();
    print("GOOGLE İLE OTURUM  açan user id:" + _sonuc!.userID.toString());
  }

  void _facebookIleGiris(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context,
        listen:
            false); // BUTON İÇİ LİSTENER FALSE YAPILIR NEDENİ METOD CAGİRMA İSLEMLERİ CART CURT
    User1? _sonuc = await _usermodel.sigInWithFacebook();
    print("FACEBOOK İLE OTURUM  açan user id:" + _sonuc!.userID.toString());
  }

  void _emailveSifreileGiris(BuildContext context) async {
    Navigator.of(context).push(MaterialPageRoute(
        fullscreenDialog: true, builder: ((context) => EmailveSifreLogin())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter lovers"),
        elevation: 0,
      ),
      backgroundColor: Colors.grey.shade200,
      body: Container(
        color: Color.fromARGB(255, 220, 243, 222),
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Oturum Açın",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            SizedBox(
              height: 8,
            ),
            SocialLoginButton(
              butonText: "Gmail ile Giriş yap",
              butonIcon: Image.asset("images/google-logo.png"),
              onpressed: () => _googleIleGiris(context),
              butonColor: Colors.white,
              textColor: Colors.black87,
            ),
            SocialLoginButton(
              butonColor: Color.fromARGB(255, 20, 218, 109),
              butonText: "Email ve Şifre İle Giriş Yap",
              textColor: Colors.white,
              onpressed: () => _emailveSifreileGiris(context),
              radius: 16,
              butonIcon: Icon(
                Icons.mail,
                size: 32,
              ),
            ),
            SocialLoginButton(
              butonColor: Color(0xFF334D92),
              butonText: "Facebook İle Giriş Yap",
              textColor: Colors.white,
              onpressed: () => _facebookIleGiris(context),
              radius: 16,
              butonIcon: Image.asset("images/facebook-logo.png"),
            ),
            SocialLoginButton(
              butonColor: Color.fromARGB(255, 85, 126, 241),
              butonText: "Misafir girişi",
              textColor: Colors.white,
              onpressed: () => _misafirGirisi(context),
              radius: 16,
              butonIcon: Icon(Icons.face),
            ),
          ],
        ),
      ),
    );
  }
}
