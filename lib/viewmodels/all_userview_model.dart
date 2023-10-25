import 'package:flutter/cupertino.dart';
import 'package:ilkvisual/app/profilsayfasi.dart';
import 'package:ilkvisual/repository/user_reposiyory.dart';

import '../locator.dart';
import '../model/user.dart';

enum AllUserViewState { Idle, Loaded, Busy }

class AllUserViewModel with ChangeNotifier {
  final UserRepository _userRepository = locator<UserRepository>();
  AllUserViewState _state = AllUserViewState.Idle;
  List<User1>? _tumKullanicilar;
  User1? _lastgetUser;
  final _sayfabasikackisi = 10;
  bool _dahaVarmi = true;
  bool get dahaVarmi => _dahaVarmi;
  List<User1>? get kullanicilarListesi => _tumKullanicilar;
  AllUserViewState get state => _state;
  set state(AllUserViewState value) {
    _state = value;
    notifyListeners();
  }

  //nesne üretildiginde ilk calısıcak yer
  AllUserViewModel() {
    _tumKullanicilar = [];
    _lastgetUser = null;
    getUsersWithPagination(_lastgetUser, false);
  }
  //refresh ve sayfalama için
  //yenielemanlar getir true yapılır
  //ilk açılıs için yeni elemanlar için false olmalıdır
  Future<void> getUsersWithPagination(
      User1? enSonGetUser, bool newUserGet) async {
    if (_tumKullanicilar!.length > 0) {
      _lastgetUser = _tumKullanicilar!.last;
      //print("ensonuser" + stringNulltoString(_lastgetUser!.userName));
    }
    if (newUserGet) {
    } else {
      state = AllUserViewState.Busy;
    }

    var yeniListe = await _userRepository.getUsersWithPagination(
        _lastgetUser, _sayfabasikackisi);

    if (yeniListe.length < _sayfabasikackisi) {
      _dahaVarmi = false;
    }

    _tumKullanicilar!.addAll(yeniListe);
    //_tumKullanicilar!.add(yeniListe[0]);
    for (var usr in yeniListe) {
      // print("Getirilen username:" + stringNulltoString(usr.userName));
    }
    state = AllUserViewState.Loaded;
  }

  Future<void> moreUserGet() async {
    print("viewwmodelmoreuserGetEEEEEEEEEEEEEEEEEEEETİRRRRR");
    if (_dahaVarmi) {
      await getUsersWithPagination(_lastgetUser, true);
    } else {
      print("eleman yok cagirilmiyacakkkkk");
    }

    await Future.delayed(const Duration(seconds: 1));
  }

  Future<Null> refresh() async {
    _dahaVarmi = true;
    _lastgetUser = null;
    _tumKullanicilar = [];
    getUsersWithPagination(_lastgetUser, true);
    //false olsaydı sayfa busy durumuna düser proress cıkardı
    // tru ytaptık cünki prgressindicatior görmek istemedim
  }
}
