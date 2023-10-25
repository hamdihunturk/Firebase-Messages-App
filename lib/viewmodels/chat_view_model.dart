import 'dart:async';

import "package:flutter/material.dart";
import 'package:provider/provider.dart';

import '../locator.dart';
import '../model/message_model.dart';
import '../model/user.dart';
import '../repository/user_reposiyory.dart';

enum ChatViewState { Idle, Busy, Loaded }

class ChatViewModel with ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();
  List<Mesaj>? _tumMesajlar;
  ChatViewState _state = ChatViewState.Idle;
  final _sayfabasikackisi = 16;
  final User1? currentUser;
  final User1? sohbetedilenUser;
  Mesaj? _ensonMesaj;
  Mesaj? _listeyeilkMesaj;
  bool _yeniMesajDinleListener = false;
  bool _dahaVarmi = true;
  bool get dahaVarmii => _dahaVarmi;

  StreamSubscription? _streamSubscription;

  List<Mesaj>? get mesajlarListesi => _tumMesajlar;
  ChatViewState get state => _state;
  set state(ChatViewState value) {
    _state = value;
    notifyListeners();
  }

  @override
  dispose() {
    _streamSubscription!.cancel;
    print("dispose oldu");
    // super.dispose();
  }

  ChatViewModel({this.currentUser, this.sohbetedilenUser}) {
    _tumMesajlar = [];
    getMessageWithPagination(false);
  }
  Future<bool> saveMessage(Mesaj kaydedilecMesaj) async {
    return await _userRepository.saveMessage(kaydedilecMesaj);
  }

  void getMessageWithPagination(bool yeniMesajlar) async {
    if (_tumMesajlar!.length > 0) {
      _ensonMesaj = _tumMesajlar!.last;
    }

    if (!yeniMesajlar) {
      state = ChatViewState.Busy;
    }

    var getMessage = await _userRepository.getMessageWithPagination(
        currentUser!.userID,
        sohbetedilenUser!.userID,
        _ensonMesaj,
        _sayfabasikackisi);
    if (getMessage.length < _sayfabasikackisi) {
      _dahaVarmi = false;
    }
    _tumMesajlar!.addAll(getMessage);

    if (_tumMesajlar!.length > 0) {
      _listeyeilkMesaj = _tumMesajlar!.first;
      debugPrint("İLK MESAJHHHHHJHHHHH ${_listeyeilkMesaj!.message}");
    }

    state = ChatViewState.Loaded;

    if (_yeniMesajDinleListener == false) {
      _yeniMesajDinleListener = true;
      yeniMesajListenerGet();
    }
  }

  Future<void> moreMessageGet() async {
    print("viewwmodelmoreuserGetEEETİRR   TETİKLENDİ");
    if (_dahaVarmi) {
      getMessageWithPagination(true);
    } else {
      print("eleman yok cagirilmiyacakkkkk");
    }

    await Future.delayed(const Duration(seconds: 1));
  }

  void yeniMesajListenerGet() {
    print("METHOD IN");
    _streamSubscription = _userRepository
        .getMessage(currentUser!.userID, sohbetedilenUser!.userID)
        .listen((anlikData) {
      if (anlikData.isNotEmpty) {
        debugPrint("LISTENER GET DATA=>>>${anlikData[0].toString()}");

        if (anlikData[0].date != null) {
          if (_listeyeilkMesaj == null) {
            // öncedfen konusma olmamıs birine ilk mesaj null döner bunun kontunu yapmamız lazımdı
            _tumMesajlar!.insert(0, anlikData[0]);
          } else if (_listeyeilkMesaj!.date!.millisecondsSinceEpoch !=
              anlikData[0].date!.millisecondsSinceEpoch) {
            //milli second ilk açıldıgında 2 eleman getirilmemesi için cünki listener ilk elemanı tekrar okuyor basta
            _tumMesajlar!.insert(0, anlikData[0]);
          }
        }

        state = ChatViewState.Loaded;
      }
    });
  }
}
