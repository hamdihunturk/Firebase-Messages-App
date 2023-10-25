// ignore_for_file: no_leading_underscores_for_local_identifiers, prefer_const_constructors, duplicate_ignore

import 'dart:io';

import 'package:cross_file_image/cross_file_image.dart';
import 'package:flutter/material.dart';
import 'package:ilkvisual/common_widget/platform_duyarli_alert.dart';
import 'package:ilkvisual/common_widget/social_log_in_button.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../viewmodels/usermodel.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  TextEditingController? _contUserName;
  File? file;
  final ImagePicker _picker = ImagePicker();
  @override
  void initState() {
    super.initState();
    _contUserName = TextEditingController();
  }

  @override
  void dispose() {
    _contUserName!.dispose();
    super.dispose();
  }

  void _kameradanCek() async {
    var _yeniresim = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (_yeniresim != null) {
        file = File(_yeniresim.path);
        Navigator.of(context).pop();
      } else {
        debugPrint("SDASDASASDASD");
      }
    });
  }

  void _galeridenSec() async {
    var _yeniresim = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (_yeniresim != null) {
        file = File(_yeniresim.path);
        Navigator.of(context).pop();
      } else {
        debugPrint("SDASDASASDASD");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    UserModel _usermodel = Provider.of<UserModel>(context);
    _contUserName!.text = _usermodel.user!.userName!;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profil "),
        actions: [
          TextButton(
              onPressed: () => cikisIcinIzin(context),
              child: const Text(
                "çıkış",
                style: TextStyle(
                    color: Color.fromARGB(221, 248, 248, 248), fontSize: 16),
              ))
        ],
      ),
      body: SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: ((context) {
                      return SizedBox(
                        height: 190,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.camera),
                              title: Text("Fotoğraf çek"),
                              onTap: (() {
                                _kameradanCek();
                              }),
                            ),
                            ListTile(
                              leading: Icon(Icons.image),
                              title: Text("Galeriden seç"),
                              onTap: (() {
                                _galeridenSec();
                              }),
                            )
                          ],
                        ),
                      );
                    }));
              },
              child: CircleAvatar(
                  radius: 75,
                  /*backgroundImage:  file == null
                      ? Image(
                          image:
                              NetworkImage("https://picsum.photos/250?image=9"),  // imageprovider calisilmali
                        )
                      : Image(image: XFileImage(file!)),,*/
                  /*child: Container(
                    decoration: file == null
                        ? BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                  "https://picsum.photos/250?image=9",
                                  scale: 0.5),
                            ))
                        : BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: XFileImage(file!),
                            ))
                    /*child: file == null
                      ? Image(
                          image: NetworkImage(
                              "https://picsum.photos/250?image=9",
                              scale: 0.5),
                        )
                      : Image(image: XFileImage(file!)),*/
                    ),*/
                  child: file == null
                      ? Container(
                          decoration: BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: NetworkImage(stringNulltoString(
                                    _usermodel.user!.profilUrl)),
                              )))
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.file(
                            file!,
                            width: 250,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        )),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                initialValue: _usermodel.user!.email,
                readOnly: true,
                decoration: InputDecoration(
                  label: Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(17),
                    ),
                  ),
                ),
              )),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _contUserName,
                decoration: InputDecoration(
                  label: Icon(Icons.verified_user),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(17),
                    ),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SocialLoginButton(
                butonText: "Değişiklikleri Kaydet",
                butonIcon: Opacity(
                  opacity: 0,
                  child: Icon(Icons.ac_unit),
                ),
                onpressed: (() {
                  _userNameGuncelle(context);
                  _profilFotoGuncelle(context);
                })),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text("xzxzxz"),
              ))
        ],
      ))),
    );
  }

  void _userNameGuncelle(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);
    if (_usermodel.user!.userName != _contUserName!.text) {
      var updateRestul = await _usermodel.updateUserName(
          _usermodel.user!.userID, _contUserName!.text);

      if (updateRestul) {
        // ignore: use_build_context_synchronously
        await PlatformDuyarliAlert(
                baslik: "Başarılı",
                icerik: "Username değiştirildi",
                butonyzi: "Tamam")
            .goster(context);
      } else {
        _contUserName!.text = _usermodel.user!.userName!;
        // ignore: use_build_context_synchronously
        await PlatformDuyarliAlert(
                baslik: "Hata",
                icerik:
                    "Username zaten kullanımda farklı bir username deneyiniz",
                butonyzi: "Tamam")
            .goster(context);
      }
    }
  }

  void _profilFotoGuncelle(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);

    if (file != null) {
      var url = await _usermodel.uploadFile(
          _usermodel.user!.userID, "profil_foto", file);
      if (url != null) {
        // ignore: use_build_context_synchronously
        PlatformDuyarliAlert(
          baslik: "Başarılı",
          icerik: "Profil fotoğrafınız güncellendi",
          butonyzi: 'Tamam',
        ).goster(context);
      }
    }
    debugPrint("sdadsadasdasda ++++  ${_usermodel.user!.profilUrl}");
  }
}

Future<bool> cikisYap(BuildContext context) async {
  final _usermodel = Provider.of<UserModel>(context, listen: false);
  bool sonuc = await _usermodel.signOut1();
  return sonuc;
}

Future cikisIcinIzin(BuildContext context) async {
  final sonuc = await PlatformDuyarliAlert(
    baslik: "Emin misiniz?",
    icerik: "Çıkmak istediğinizden emin misiniz?",
    butonyzi: "evet",
    iptalAksiyon: "Vazgeç",
  ).goster(context);
  // ignore: unrelated_type_equality_checks
  if (sonuc == true) {
    await cikisYap(context); //????* await kaldırılabilir
  }
}

stringNulltoString(String? profilUrl) {
  return "$profilUrl";
}
