// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers, sort_child_properties_last, unused_field, prefer_final_fields

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ilkvisual/app/kullanicilar.dart';
import 'package:ilkvisual/app/my_custom_buttom.dart';
import 'package:ilkvisual/app/profilsayfasi.dart';
import 'package:ilkvisual/app/tap_items.dart';
import 'package:ilkvisual/viewmodels/all_userview_model.dart';
import 'package:provider/provider.dart';
import '../model/user.dart';
import 'konusmalarim_page.dart';

class HomePage extends StatefulWidget {
  final User1? user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final appAcikken = FirebaseMessaging.onMessage;
  final appArkaPlanda = FirebaseMessaging.onMessageOpenedApp;

  TabItems _currentTab = TabItems.Kullanicilar;

  Map<TabItems, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItems.Kullanicilar: GlobalKey<NavigatorState>(),
    TabItems.Profil: GlobalKey<NavigatorState>(),
    TabItems.Konusmalarim: GlobalKey<NavigatorState>(),
  };

  Map<TabItems, Widget> tumSayfalar() {
    return {
      TabItems.Kullanicilar: ChangeNotifierProvider(
        child: KullanicilarPAge(),
        create: ((context) => AllUserViewModel()),
      ),
      TabItems.Profil: ProfilPage(),
      TabItems.Konusmalarim: KonusmalarimPage(),
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // workaround for onLaunch: When the app is completely closed (not in the background) and opened directly from the push notification
    _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('getInitialMessage data: ${message.data}');
      } else {
        debugPrint("null geldi amk");
      }
    });

    // onMessage: When the app is open and it receives a push notification
    appAcikken.listen((RemoteMessage message) {
      print("onMessage data: ${message.data}");
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    appArkaPlanda.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !await navigatorKeys[_currentTab]!.currentState!.maybePop(),
      child: MyCustomButtomNavigator(
        navigatorKeys: navigatorKeys,
        sayfaOlusturucu: tumSayfalar(),
        currentTab: _currentTab,
        onSelecedTab: (secilenTab) {
          if (secilenTab == _currentTab) {
            navigatorKeys[secilenTab]!
                .currentState
                ?.popUntil((route) => route.isFirst);
          } else {
            setState(() {
              _currentTab = secilenTab;

              //  ALLTAKİ İF NE İCİN YAZILMISTIR
              //  Konusmalarım tabına tıkladığında konusmalarımPage buil edilmiyor yani uygulama ilk başlatılıdığında
              //  build ediliyor devamında bir kullanıcıyla konusursanız konusmlarım kısmına eklenmez
              //  buna karsı çözüm konusmlarım tabına tıklandıgına hotreload voidini cagirmaktır
              //  kötü çözüm
              if (_currentTab == TabItems.Konusmalarim) {
                (context as Element).reassemble();
              }
            });
          }

          debugPrint("Secilen tab item $secilenTab");
        },
      ),
    );
  }
}
/*
Future<bool> cikisYap(BuildContext context) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);
    bool sonuc = await _usermodel.signOut1();
    return sonuc;
  }*/
