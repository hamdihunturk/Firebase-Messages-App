// ignore_for_file: prefer_interpolation_to_compose_strings, no_leading_underscores_for_local_identifiers

import 'package:flutter/cupertino.dart';
import 'package:ilkvisual/app/konusma.dart';
import 'package:ilkvisual/model/message_model.dart';
import 'package:ilkvisual/model/user.dart';
import 'package:ilkvisual/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/konusmalar.dart';

class FirestoreDBservice implements DBbase {
  final FirebaseFirestore _firestoreDB = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(User1 user1) async {
    await _firestoreDB.collection("users").doc(user1.userID).set(user1.toMap());
    DocumentSnapshot okunanUser =
        await FirebaseFirestore.instance.doc("users/${user1.userID}").get();

    Map<String, dynamic> okunanUserMapBilgileri =
        okunanUser.data() as Map<String, dynamic>;
    User1 okunanUserBilgiNesne = User1.fromMap(okunanUserMapBilgileri);
    debugPrint("okunan user nesnesi : " + okunanUserBilgiNesne.toString());

    return true;
  }

  @override
  Future<User1> readUser(String userID) async {
    DocumentSnapshot _okunanuser =
        await _firestoreDB.collection("users").doc(userID).get();
    Map<String, dynamic> _okunanuserMap =
        _okunanuser.data() as Map<String, dynamic>;
    User1 _okunanNesne = User1.fromMap(_okunanuserMap);
    debugPrint("OKUNAN USER NESNESİ: 222" + _okunanNesne.toString());
    return _okunanNesne;
  }

  @override
  Future<bool> updateUserName(String userID, String yeniUsername) async {
    var users = await _firestoreDB
        .collection("users")
        .where("userName", isEqualTo: yeniUsername)
        .get();
    if (users.docs.length >= 1) {
      // 1 den büyükse böyle bir username vardır
      return false;
    } else {
      await _firestoreDB
          .collection("users")
          .doc(userID)
          .update({'userName': yeniUsername});
      return true;
    }
  }

  @override
  Future<bool> updateProfilFoto(String userID, String profilFotoURL) async {
    await _firestoreDB
        .collection("users")
        .doc(userID)
        .update({'profilUrl': profilFotoURL});
    return true;
  }

  //kullanılmayan metod
  @override
  Future<List<User1>?> getAllUsers() async {
    QuerySnapshot _query = await _firestoreDB.collection("users").get();

    List<User1> tumKullaniclar = [];
    for (DocumentSnapshot tekUser in _query.docs) {
      User1 _tekUser = User1.fromMap(tekUser.data() as Map<String, dynamic>);
      tumKullaniclar.add(_tekUser);
    }
    //Map metodu ile
    /*
    tumKullaniclar = _query.docs
        .map((teksatir) =>
            User1.fromMap(teksatir.data() as Map<String, dynamic>))
        .toList();*/
    return tumKullaniclar;
  }
/*
  @override
  Stream<List<Mesaj>> getMassage(String currentUSer, String karsiTarafId) {
    var snapShot = _firestoreDB
        .collection("Konusmalar")
        .doc(currentUSer + "--" + karsiTarafId)
        .collection("mesajlar")
        .orderBy("date")
        .snapshots();
    throw snapShot.map((mesajlarListesi) => mesajlarListesi.docs
        .map((e) => Mesaj.fromMap(e.data()))
        .toList()); //Mesajların Liste olarak firestora atanması
  }*/

  @override
  Stream<List<Mesaj>> getMassage(
      String currentUserID, String sohbetEdilenUserID) {
    var snapShot = _firestoreDB
        .collection("konusmalar")
        .doc(currentUserID + "--" + sohbetEdilenUserID)
        .collection("mesajlar")
        //.where("konusma_sahibi", isEqualTo: currentUserID)
        .orderBy("date", descending: true /*tarihi son olanı öne koyar*/)
        .limit(1)
        .snapshots();

    return snapShot.map((mesajListesi) =>
        mesajListesi.docs.map((mesaj) => Mesaj.fromMap(mesaj.data())).toList());
  }

  @override
  Future<bool> saveMessage(Mesaj kaydedilecMesaj) async {
    var mesajID = _firestoreDB.collection("konusmalar").doc().id;
    var _myDocID = kaydedilecMesaj.kimden + "--" + kaydedilecMesaj.kime;
    var _alici = kaydedilecMesaj.kime + "--" + kaydedilecMesaj.kimden;
    var _kaydedilecMap = kaydedilecMesaj
        .toMap(); // bundan nesne üretince false sorunu düzeldi ilginc
    await _firestoreDB
        .collection("konusmalar")
        .doc(_myDocID)
        .collection("mesajlar")
        .doc(mesajID)
        .set(_kaydedilecMap);

    await _firestoreDB.collection("konusmalar").doc(_myDocID).set({
      "konusma_sahibi": kaydedilecMesaj.kimden,
      "kimle_konusuyor": kaydedilecMesaj.kime,
      "son_yollanan_mesaj": kaydedilecMesaj.message,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    _kaydedilecMap.update("bendenMi", (value) => false);

    await _firestoreDB
        .collection("konusmalar")
        .doc(_alici)
        .collection("mesajlar")
        .doc(mesajID)
        .set(_kaydedilecMap);

    await _firestoreDB.collection("konusmalar").doc(_alici).set({
      "konusma_sahibi": kaydedilecMesaj.kime,
      "kimle_konusuyor": kaydedilecMesaj.kimden,
      "son_yollanan_mesaj": kaydedilecMesaj.message,
      "konusma_goruldu": false,
      "olusturulma_tarihi": FieldValue.serverTimestamp(),
    });

    return true;
  }

  @override
  Future<List<KonusmaModel>> getAllConversation(String userID) async {
    QuerySnapshot _query = await _firestoreDB
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();

    List<KonusmaModel> tumConversation = [];
    for (DocumentSnapshot tekkonusma in _query.docs) {
      KonusmaModel _tekKonusma =
          KonusmaModel.fromMap(tekkonusma.data() as Map<String, dynamic>);
      //  print("gelen konusma listesi :" + tekkonusma.data().toString());
      //  print(_tekKonusma.toString());
      tumConversation.add(_tekKonusma);
    }
    return tumConversation;
  }

  @override
  Future<DateTime> saatiGoster(String userID) async {
    await _firestoreDB.collection("server").doc(userID).set({
      "saat": FieldValue.serverTimestamp(),
    });

    var okunanMap = await _firestoreDB.collection("server").doc(userID).get();
    //print("$okunanMap. SDAGDSAGSDAGDSAGADSGS");
    Timestamp okunanTarih =
        okunanMap.data()!["saat"]; // get ile cektik okunanmap datasındaki saat
    print("ALOOOOOBGÖMRMÜYONMU AMK" + okunanTarih.toString());
    return okunanTarih.toDate();
  }

  @override
  Future<List<User1>> getUsersWithPagination(
      User1? lastgetUser, int getirilecekElemanSayisi) async {
    QuerySnapshot querySnapshot;
    List<User1> _tumKullanicilar = [];
    //("ilk kullanıcılar getriliyor");
    if (lastgetUser == null) {
      // debugPrint("ilk kullanıcılar getriliyor");
      //firestore ilk 10 tane elemanı vericek ve ordby sayesinde Username i a dan z dizicek
      querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      //debugPrint("sonrakiler getiriliyor");
      querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .orderBy("userName")
          .startAfter([lastgetUser.userName])
          .limit(getirilecekElemanSayisi)
          .get();
      await Future.delayed(const Duration(
        seconds: 1,
      ));
    }
    for (var element in querySnapshot.docs) {
      User1 tekUser = User1.fromMap(element.data() as Map<String, dynamic>);
      _tumKullanicilar.add(tekUser);
      //debugPrint("Getirelen usr  name  ==> ${tekUser.userName}");
    }

    return _tumKullanicilar;
  }

  Future<List<Mesaj>> getMessageWithPagination(String? userID, String? userID2,
      Mesaj? ensonMesaj, int getirilecekElemanSayisi) async {
    QuerySnapshot querySnapshot;
    List<Mesaj> _tumMesajlar = [];
    //("ilk kullanıcılar getriliyor");
    if (ensonMesaj == null) {
      // debugPrint("ilk kullanıcılar getriliyor");
      //firestore ilk 10 tane elemanı vericek ve ordby sayesinde Username i a dan z dizicek
      querySnapshot = await FirebaseFirestore.instance
          .collection("konusmalar")
          .doc(userID! + "--" + userID2!)
          .collection("mesajlar")
          //.where("konusmaSahibi", isEqualTo: currentUserID)
          .orderBy("date", descending: true /*tarihi son olanı öne koyar*/)
          .limit(getirilecekElemanSayisi)
          .get();
    } else {
      //debugPrint("sonrakiler getiriliyor");
      querySnapshot = await FirebaseFirestore.instance
          .collection("konusmalar")
          .doc(userID! + "--" + userID2!)
          .collection("mesajlar")
          //.where("konusmaSahibi", isEqualTo: currentUserID)
          .orderBy("date", descending: true /*tarihi son olanı öne koyar*/)
          .startAfter([ensonMesaj.date])
          .limit(getirilecekElemanSayisi)
          .get();
      await Future.delayed(const Duration(
        seconds: 1,
      ));
    }
    for (var element in querySnapshot.docs) {
      Mesaj tekUser = Mesaj.fromMap(element.data() as Map<String, dynamic>);
      _tumMesajlar.add(tekUser);
      //debugPrint("Getirelen usr  name  ==> ${tekUser.userName}");
    }

    return _tumMesajlar;
  }
}
