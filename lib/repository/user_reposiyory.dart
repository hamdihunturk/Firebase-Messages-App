// ignore_for_file: unused_field, prefer_final_fields, no_leading_underscores_for_local_identifiers

import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:ilkvisual/locator.dart';
import 'package:ilkvisual/model/konusmalar.dart';
import 'package:ilkvisual/model/message_model.dart';
import 'package:ilkvisual/model/user.dart';
import 'package:ilkvisual/services/auth_base.dart';
import 'package:ilkvisual/services/fake_auth_services.dart';
import 'package:ilkvisual/services/firebase_auth_service.dart';
import 'package:ilkvisual/services/firebase_stroge_service.dart';
import 'package:ilkvisual/services/firestore_db_service.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: constant_identifier_names
enum AppMode { DEBUG, RELASE }

class UserRepository implements AuthBase {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  FakeAuthService _fakeAuthService = locator<FakeAuthService>();
  FirestoreDBservice _firestoreDBservice = locator<FirestoreDBservice>();
  FirebaseStrogeService _firebaseStrogeService =
      locator<FirebaseStrogeService>();

  AppMode appMode = AppMode.RELASE;
  List<User1> tumKullaniciListesi = [];
  @override
  Future<User1?> currentUser1() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.currentUser1();
    } else {
      User1? _user = await _firebaseAuthService.currentUser1();
      return await _firestoreDBservice.readUser(_user!.userID);
    }
  }

  @override
  Future<User1?> signInAnonymously1() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signInAnonymously1();
    } else {
      return await _firebaseAuthService.signInAnonymously1();
    }
  }

  @override
  Future<bool> signOut1() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.signOut1();
    } else {
      return await _firebaseAuthService.signOut1();
    }
  }

  @override
  Future<User1?> sigInWithGoogle() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.sigInWithGoogle();
    } else {
      User1? _user = await _firebaseAuthService.sigInWithGoogle();
      bool _sonuc = await _firestoreDBservice.saveUser(_user!);
      if (_sonuc) {
        return await _firestoreDBservice.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User1?> sigInWithFacebook() async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.sigInWithFacebook();
    } else {
      User1? _user = await _firebaseAuthService.sigInWithFacebook();
      bool _sonuc = await _firestoreDBservice.saveUser(_user!);
      if (_sonuc) {
        return await _firestoreDBservice.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User1?> createUserWithEmailandPassword(
      String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.createUserWithEmailandPassword(
          email, sifre);
    } else {
      User1? _user = await _firebaseAuthService.createUserWithEmailandPassword(
          email, sifre);
      bool _sonuc = await _firestoreDBservice.saveUser(_user!);
      if (_sonuc) {
        return await _firestoreDBservice.readUser(_user.userID);
      } else {
        return null;
      }
    }
  }

  @override
  Future<User1?> sigInWithEmailandPassword(String email, String sifre) async {
    if (appMode == AppMode.DEBUG) {
      return await _fakeAuthService.sigInWithEmailandPassword(email, sifre);
    } else {
      User1? _user =
          await _firebaseAuthService.sigInWithEmailandPassword(email, sifre);
      return await _firestoreDBservice.readUser(_user!.userID);
    }
  }

  Future<bool> updateUserName(String userID, String yeniUsername) async {
    if (appMode == AppMode.DEBUG) {
      return false;
    } else {
      return await _firestoreDBservice.updateUserName(userID, yeniUsername);
    }
  }

  Future<String?> uploadFile(String userID, String fileType, File? file) async {
    if (appMode == AppMode.DEBUG) {
      return "dosya indirme link";
    } else {
      var profilUrl =
          await _firebaseStrogeService.uploadFile(userID, fileType, file!);
      await _firestoreDBservice.updateProfilFoto(userID, profilUrl);

      return profilUrl;
    }
  }

  Future<List<User1>?> getAllUsers() async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      tumKullaniciListesi = (await _firestoreDBservice.getAllUsers())!;
      return tumKullaniciListesi;
    }
  }

  Stream<List<Mesaj>> getMessage(
      String currentUSerID, String sohbetedilenUserID) {
    if (appMode == AppMode.DEBUG) {
      return const Stream.empty();
    } else {
      return _firestoreDBservice.getMassage(currentUSerID, sohbetedilenUserID);
    }
  }

  Future<bool> saveMessage(Mesaj kaydedilecMesaj) async {
    if (appMode == AppMode.DEBUG) {
      return true;
    } else {
      return _firestoreDBservice.saveMessage(kaydedilecMesaj);
    }
  }

  Future<List<KonusmaModel>> getAllConversation(String userID) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      DateTime _zaman = await _firestoreDBservice.saatiGoster(userID);

      var konusmaListesi = await _firestoreDBservice.getAllConversation(userID);
      for (var oankiKonusma in konusmaListesi) {
        var userListesindekiKullanici =
            ListedeUserBul(oankiKonusma.kimle_konusuyor!);
        //internete en basında gittiği için getAlluser metdou sayesinde internete gitmeden önceden konusulan kisiye ulasabiliriz
        // internet yani veri tabanı
        if (userListesindekiKullanici != null) {
          print("Local cachden geldi");
          oankiKonusma.konusulanUserName = userListesindekiKullanici.userName;
          oankiKonusma.konusulanUserFoto = userListesindekiKullanici.profilUrl;
        } else {
          print(
              "VERİ TABANINDAN OKUNDU,,,ARANILAN USER DAHA ÖNCEDEN VERİ TABANINDAN GETİRLMEMİSTİR");
          var veritabaniokunan =
              await _firestoreDBservice.readUser(oankiKonusma.kimle_konusuyor!);
          oankiKonusma.konusulanUserName = veritabaniokunan.userName;
          oankiKonusma.konusulanUserFoto = veritabaniokunan.profilUrl;
        }
        timeagoHesapla(oankiKonusma, _zaman);
      }

      return konusmaListesi;
    }
  }

  User1? ListedeUserBul(String userID) {
    for (var i = 0; i < tumKullaniciListesi.length; i++) {
      if (tumKullaniciListesi[i].userID == userID) {
        return tumKullaniciListesi[i];
      }
    }
    return null;
  }

  void timeagoHesapla(KonusmaModel oankiKonusma, DateTime zaman) {
    oankiKonusma.sonOkunmaZamani = zaman;
    //setLocaleMessages ile locali ayarlıyıp formattan locali ayarladım
    // bu sayede tr seklinde yazıldı
    timeago.setLocaleMessages("tr", timeago.TrMessages());
    //duration türüde veri olusturup
    //veri tabanından konusma olusturma tarihini çektik
    // ve bu veriyi _zamandan cıkardıık (_zaman = server saaati)
    var duration = zaman.difference(oankiKonusma.olusturulma_tarihi!.toDate());
    oankiKonusma.aradakiFark =
        timeago.format(zaman.subtract(duration), locale: "tr");
  }

  Future<List<User1>> getUsersWithPagination(
      User1? sonUser, int getirilecekElemanCount) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      //Local cachten gelmesi icin böyle bir yöntem kullandık herdefasında veritabanına gidiyordu cünki
      List<User1> _userList = await _firestoreDBservice.getUsersWithPagination(
          sonUser, getirilecekElemanCount);
      tumKullaniciListesi.addAll(_userList);
      return _userList;
    }
  }

  Future<List<Mesaj>> getMessageWithPagination(String? userID, String? userID2,
      Mesaj? ensonMesaj, int getirilecekElemanSayisi) async {
    if (appMode == AppMode.DEBUG) {
      return [];
    } else {
      return await _firestoreDBservice.getMessageWithPagination(
          userID, userID2, ensonMesaj, getirilecekElemanSayisi);
    }
  }
}
