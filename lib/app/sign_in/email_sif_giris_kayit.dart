// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers, prefer_if_null_operators, curly_braces_in_flow_control_structures

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ilkvisual/app/hata_exception.dart';
import 'package:ilkvisual/common_widget/platform_duyarli_alert.dart';
import 'package:ilkvisual/common_widget/social_log_in_button.dart';
import 'package:ilkvisual/viewmodels/usermodel.dart';
import 'package:provider/provider.dart';
import '../../model/user.dart';

// ignore: constant_identifier_names
enum FormType { Register, Login }

class EmailveSifreLogin extends StatefulWidget {
  const EmailveSifreLogin({super.key});

  @override
  State<EmailveSifreLogin> createState() => _EmailveSifreLoginState();
}

class _EmailveSifreLoginState extends State<EmailveSifreLogin> {
  String? _email, _sifre;
  late String _butonText, _linkText;
  var _formType = FormType.Login;
  final _formKey = GlobalKey<FormState>();

  void _formSubmit() async {
    _formKey.currentState?.save();
    debugPrint("+_email  " + _email! + "sifre:   " + _sifre!);
    final _userModel = Provider.of<UserModel>(context, listen: false);

    if (_formType == FormType.Login) {
      try {
        User1? _girisyapanUSer =
            await _userModel.sigInWithEmailandPassword(_email!, _sifre!);
        if (_girisyapanUSer != null)
          debugPrint("email ve password ile giriş yapan user :" +
              _girisyapanUSer.userID.toString());
      } on FirebaseAuthException catch (e) {
        debugPrint("WİDGET oturum açma HATA" + e.code.toString());
        PlatformDuyarliAlert(
          baslik: "Oturum açma hata",
          icerik: Hatalar.goster(e.code),
          butonyzi: 'Tamam',
        ).goster(context);
      }
    } else {
      try {
        User1? _createedilenuser =
            await _userModel.createUserWithEmailandPassword(_email!, _sifre!);
        if (_createedilenuser != null)
          debugPrint("create edilen  moryj user :" +
              _createedilenuser.userID.toString());
      } on FirebaseAuthException catch (e) {
        //PlatformException'in yerini FirebaseAuthException aldı
        debugPrint("WİDGET kullanici olustuma HATA" + Hatalar.goster(e.code));
        PlatformDuyarliAlert(
          baslik: "Kullanıcı Oluşturma hata",
          icerik: Hatalar.goster(e.code),
          butonyzi: 'Tamam',
        ).goster(context);
      }
    }
  }

  void _degistir() {
    setState(() {
      _formType =
          _formType == FormType.Login ? FormType.Register : FormType.Login;
    });
  }

  @override
  Widget build(BuildContext context) {
    _butonText = _formType == FormType.Login ? "Giriş yap" : "Kayıt ol";
    _linkText = _formType == FormType.Login
        ? "Hesabınız yok mu? Kayıt olun"
        : "Hesabınız var mı? Giriş yapın";

    final _userModel = Provider.of<UserModel>(context);

    ///???

    if (_userModel.user != null) {
      /*
        Future.delayed(Duration.zero,(){
            Navigator.of(context).pop();
        });*/
      //Navigator.of(context).pop();
      Future.delayed(Duration(microseconds: 250), () {
        Navigator.of(context).pop(); //____???????????????????????
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Giriş/Kayıt"),
        ),
        // ignore: prefer_const_constructors
        body: _userModel.state == ViewState.Idle
            ? SingleChildScrollView(
                child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: "hamdi@hamdi.com",
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            errorText: _userModel.emailHata != null
                                ? _userModel.emailHata
                                : null,
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'email',
                            label: Text('email'),
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (String? girilenemail) {
                            _email = girilenemail;
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextFormField(
                          initialValue: "Sifre55",
                          obscureText: true,
                          decoration: InputDecoration(
                            errorText: _userModel.sifreHata != null
                                ? _userModel.sifreHata
                                : null,
                            prefixIcon: Icon(Icons.mail),
                            hintText: 'sifre',
                            label: Text('sifre'),
                            border: OutlineInputBorder(),
                          ),
                          onSaved: (String? girilensif) {
                            _sifre = girilensif;
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        SocialLoginButton(
                          butonText: _butonText,
                          butonIcon: Icon(Icons.ac_unit_sharp),
                          onpressed: () => _formSubmit(),
                          butonColor: Theme.of(context).primaryColor,
                          radius: 10,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextButton(
                            onPressed: () => _degistir(),
                            child: Text(_linkText))
                      ],
                    )),
              ))
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
