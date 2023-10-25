// ignore_for_file: constant_identifier_names, unused_field, prefer_final_fields, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:cross_file/src/types/interface.dart';
import 'package:flutter/foundation.dart';
import 'package:ilkvisual/locator.dart';
import 'package:ilkvisual/model/konusmalar.dart';
import 'package:ilkvisual/model/message_model.dart';
import 'package:ilkvisual/model/user.dart';
import 'package:ilkvisual/repository/user_reposiyory.dart';
import 'package:ilkvisual/services/auth_base.dart';

enum ViewState { Idle, Busy }

class UserModel with ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  UserRepository _userRepository = locator<UserRepository>();
  User1? _user;
  String? emailHata;
  String? sifreHata;

  User1? get user => _user;
  ViewState get state => _state;
  set state(ViewState value) {
    _state = value;
    notifyListeners();
    //_state = value;
  }

  UserModel() {
    currentUser1();
  }

  @override
  Future<User1?> currentUser1() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser1();
      // notifyListeners();
      return _user;
    } catch (e) {
      debugPrint("Viewmodel currun user  hata ++++++!!!!!!!!" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User1?> signInAnonymously1() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.signInAnonymously1();
      // notifyListeners(); EMİN DEGİLİM
      return _user;
    } catch (e) {
      debugPrint("SİGN ANNOOOOOSYLY HATA   ++++++!!!!!!!!" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> signOut1() async {
    try {
      state = ViewState.Busy;
      bool sonuc = await _userRepository.signOut1();
      // notifyListeners(); emin degilim
      _user = null;
      return sonuc;
    } catch (e) {
      debugPrint("signout hataaaAAAAAAAAAAAAAAAA !!!!!!!!" + e.toString());
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User1?> sigInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.sigInWithGoogle();
      // notifyListeners(); EMİN DEGİLİM
      return _user;
    } catch (e) {
      debugPrint("SİGN ANNOOOOOSYLY HATA   ++++++!!!!!!!!" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User1?> sigInWithFacebook() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.sigInWithFacebook();
      // notifyListeners(); EMİN DEGİLİM
      return _user;
    } catch (e) {
      debugPrint("SİGN ANNOOOOOSYLY HATA   ++++++!!!!!!!!" + e.toString());
      return null;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<User1?> createUserWithEmailandPassword(
      String email, String sifre) async {
    if (_emailSifreKontrol(email, sifre)) {
      try {
        state = ViewState.Busy;
        _user =
            await _userRepository.createUserWithEmailandPassword(email, sifre);
      } finally {
        state = ViewState.Idle;
      }
      return _user;
    } else {
      return null;
    }
  }

  @override
  Future<User1?> sigInWithEmailandPassword(String email, String sifre) async {
    try {
      if (_emailSifreKontrol(email, sifre)) {
        state = ViewState.Busy;
        _user = await _userRepository.sigInWithEmailandPassword(email, sifre);
        return _user;
      } else {
        return null;
      }
    } finally {
      state = ViewState.Idle;
    }
  }

  bool _emailSifreKontrol(String email, String sifre) {
    var sonuc = true;
    if (sifre.length < 5) {
      sifreHata = "en az 6 karakterli olmalı";
      sonuc = false;
    } else {
      sifreHata = null;
    }
    if (!email.contains('@')) {
      emailHata = "geçersiz email";
      sonuc = false;
    } else {
      emailHata = null;
    }

    return sonuc;
  }

  Future<bool> updateUserName(String userID, String yeniUsername) async {
    var sonuc = await _userRepository.updateUserName(userID, yeniUsername);
    if (sonuc) {
      _user!.userName = yeniUsername;
    }
    return sonuc;
  }

  Future<String?> uploadFile(String userID, String fileType, File? file) async {
    state = ViewState.Idle;
    var indirmeLink = await _userRepository.uploadFile(userID, fileType, file);

    return indirmeLink;
  }

  Future<List<User1>?> getAllUsers() async {
    var tumKullaniciListesi = await _userRepository.getAllUsers();
    return tumKullaniciListesi;
  }

  Stream<List<Mesaj>> getMassage(
      String currentUSerID, String sohbetedilenUserID) {
    return _userRepository.getMessage(currentUSerID, sohbetedilenUserID);
  }

  Future<List<KonusmaModel>> getAllConversation(String userID) async {
    return await _userRepository.getAllConversation(userID);
  }

  Future<List<User1>> getUsersWithPagination(
      User1? sonUser, int getirilecekElemanCount) async {
    return await _userRepository.getUsersWithPagination(
        sonUser, getirilecekElemanCount);
  }
}
/*service firebase.storage {
  match /b/savephoto-a1cc3.appspot.com/o {
    match /{allPaths=**} {
      // Allow access by all users
      allow read, write;
    }
  }
}*/