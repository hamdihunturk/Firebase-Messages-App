import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ilkvisual/app/konusma.dart';
import 'package:ilkvisual/app/konusmalarim_page.dart';
import 'package:ilkvisual/app/profilsayfasi.dart';
import 'package:ilkvisual/model/user.dart';
import 'package:ilkvisual/services/firestore_db_service.dart';
import 'package:ilkvisual/viewmodels/all_userview_model.dart';
import 'package:ilkvisual/viewmodels/chat_view_model.dart';
import 'package:provider/provider.dart';

import '../viewmodels/usermodel.dart';
import 'örnek_page1.dart';

class KullanicilarPAge extends StatefulWidget {
  const KullanicilarPAge({super.key});

  @override
  State<KullanicilarPAge> createState() => _KullanicilarPAgeState();
}

class _KullanicilarPAgeState extends State<KullanicilarPAge> {
  static bool _yukleniyor = false;

  //bool _dahaVarmi = true;
  // final int _getirilecekElemanCount = 10;
  //User1? _sonUser;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    /*
    //build metodu tetiklendikten sonra gelicek (context belli olduktan sorna)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUser(_sonUser);
      //late String; //ben bu String tipinde veri tutacak değişkeni erişimeden önce tanımlayacağım
      //String? //String veya null değer tutacak bir değişken
      //String! // Değişkenim null'da tutabilir ama şuan null değil emin ol sen işlemini yap
      //String?.toUpperCase // eğer Stringse gerekli fonksiyonu çalıştır nullsa es geç.
      //biz demişizki _sonUser! yani değer null gelmeyecek ama değer null geliyor.
      //
      //Çözüm olarak getUsersWithPagination clasının ilk degerini nunable yaptım (repoda ,usermodede, database,firestoreda vs)
      //
    });*/

    _scrollController.addListener((() {
      _listeScrollListener();
      /*
      (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
              !_scrollController.position.outOfRange)
          ? moreUserGet() // En Altta
          : (_scrollController.offset <=
                      _scrollController.position.minScrollExtent &&
                  !_scrollController.position.outOfRange)
              ? print("En Üstte")
              : print("scroll ediliyor");*/
    }));
  }

  @override
  Widget build(BuildContext context) {
    //final _tumKullanicilerViewModel = Provider.of<AllUserViewModel>(context);
    //_usermodel.getAllUsers();
    print("build çalıştı");
    return Scaffold(
        appBar: AppBar(
          title: const Text("Kullanicilar"),
          actions: [
            IconButton(
                onPressed: (() {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: ((context) => OrnekPage1())));
                }),
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: (() async {
                  // await getUser(son);
                }),
                icon: const Icon(Icons.abc_sharp))
          ],
        ),
        body: Consumer<AllUserViewModel>(
          builder: ((context, value, child) {
            if (value.state == AllUserViewState.Busy) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (value.state == AllUserViewState.Loaded) {
              return RefreshIndicator(
                onRefresh: value.refresh,
                child: ListView.builder(
                    controller: _scrollController,
                    itemBuilder: ((context, index) {
                      if (value.dahaVarmi &&
                          index == value.kullanicilarListesi!.length) {
                        return _yeniElemanlarYukleniyorIndicator();
                      } else if (value.kullanicilarListesi!.length == 1) {
                        return _kullaniciYokUi();
                      } else {
                        return _userListesiElemaniOlsun(index);
                      }
                    }),
                    itemCount: value.dahaVarmi
                        ? value.kullanicilarListesi!.length + 1
                        : value.kullanicilarListesi!.length

                    //+1 ile index +1 sayar yani 10
                    ),
              );
            } else {
              return Container();
            }
          }),
        ));
  }

/*
_kullanicilarListesi == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _kullaniciListOlusturVoid(),*/
  /*
  getUser(User1? sonUser) async {
    final _usermodel = Provider.of<UserModel>(context, listen: false);

    if (!_dahaVarmi) {
      print("ELEMAN KALMADI MK");
      return;
    }
    if (_yukleniyor) {
      return;
    }
    setState(() {
      _yukleniyor = true;
    });

    List<User1> users = await _usermodel.getUsersWithPagination(
        sonUser, _getirilecekElemanCount);
    if (_sonUser == null) {
      _kullanicilarListesi = [];
      _kullanicilarListesi!.addAll(users);
    } else {
      _kullanicilarListesi!.addAll(users);
    }
    print("${users.length}  <=== BURA");
    if (users.length < _getirilecekElemanCount) {
      _dahaVarmi = false;
    }

    //getirilen eleman 10dan kücükse false olur
    //buda ne demek onu konusalim
    //yani ilk basta 10 tane geliyor sonrada 10 ar 10ar gelmeye
    //devam ediyor en son 3 kisi kaldı diyelim
    //3<10 dan kücük dahavarmi false olur ve scroll yapsak bile
    //getuser döngüsünden cıkılır

    //query ilk 20 yi getirir
    //devamında ilk 20 user kullanıcılar listesine atanır
    //sonuser a son user atanır bu sayede birdahki refresh e kaldıgı yerden devam eder
    /*
    for (var element in querySnapshot.docs) {
      User1 tekUser = User1.fromMap(element.data() as Map<String, dynamic>);
      _kullanicilarListesi!.add(tekUser);
      debugPrint("Getirelen usr  name  ==> ${tekUser.userName}");
    }*/

    _sonUser = _kullanicilarListesi!.last;
    // sonusernesneni basında _ olmadan yazdıgım için liste sürekli dönüyordu
    debugPrint("en son user name ==>  ${_sonUser!.userName}");

    setState(() {
      _yukleniyor = false;
    });
  }
*/
/*
  _kullaniciListOlusturVoid() {
    if (_kullanicilarListesi!.length > 1) {
      //anlık kullanıcı +1 o haric bisi varsa görüntüle
      return RefreshIndicator(
        onRefresh: _kullaniciListesiRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemBuilder: ((context, index) {
            //print(_kullanicilarListesi!.length.toString() + "bbbybeajm");
            if (index == _kullanicilarListesi!.length) {
              return _elemalariBekleIndicatior();
            }
            return _userListesiElemaniOlsun(index);
          }),
          itemCount:
              _kullanicilarListesi!.length + 1, //+1 ile index +1 sayar yani 10
        ),
      );
    } else {
      _kullaniciYokUi();
    }
  }
*/
/*
  _elemalariBekleIndicatior() {
    return Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Opacity(
            opacity: _yukleniyor ? 1 : 0,
            child: _yukleniyor ? const CircularProgressIndicator() : null,
          ),
        ));
  }
*/
  _yeniElemanlarYukleniyorIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _userListesiElemaniOlsun(int index) {
    final _tumKullanicilerViewModel =
        Provider.of<AllUserViewModel>(context, listen: false);
    final _usermodel = Provider.of<UserModel>(context, listen: false);

    var _anlikUser = _tumKullanicilerViewModel.kullanicilarListesi![index];
    if (_anlikUser.userID == _usermodel.user!.userID) {
      return Container();
    }

    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
            builder: ((context) => ChangeNotifierProvider<ChatViewModel>(
                  create: ((context) => ChatViewModel(
                      currentUser: _usermodel.user,
                      sohbetedilenUser: _anlikUser)),
                  child: Konusma(),
                ))));
      },
      child: Card(
        child: Column(
          children: [
            const SizedBox(
              height: 1,
            ),
            ListTile(
              subtitle: Text(stringNulltoString(_anlikUser.email)),
              title: Text(stringNulltoString(_anlikUser.userName)),
              leading: CircleAvatar(
                backgroundColor: Colors.green,
                backgroundImage:
                    NetworkImage(stringNulltoString(_anlikUser.profilUrl)),
              ),
            ),
            const SizedBox(
              height: 1,
            ),
          ],
        ),
      ),
    );
  }

/*
  Future<Null> _kullaniciListesiRefresh() async {
    _dahaVarmi = true;
    _sonUser = null;
    // getUser(_sonUser);
  }
*/

  Widget _kullaniciYokUi() {
    final _kullaniciMod = Provider.of<AllUserViewModel>(context);
    return RefreshIndicator(
      onRefresh: _kullaniciMod.refresh,
      child: SingleChildScrollView(
        //physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height - 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.ice_skating,
                  color: Theme.of(context).primaryColor,
                  size: 75,
                ),
                const Text(
                  "Henüz Kullanıcı Yok",
                  style: TextStyle(fontSize: 36),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _listeScrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      print("Listenin en altındayız");
      moreUserGet1();
    }
  }

  void moreUserGet1() async {
    if (_yukleniyor == false) {
      print("Listener tetiklendi");
      _yukleniyor = true;
      final tumKullanicilerViewModel =
          Provider.of<AllUserViewModel>(context, listen: false);
      await tumKullanicilerViewModel.moreUserGet();
      _yukleniyor = false;

      print("Listener tetiklendi bitti");
    } else {
      print("VOİD İCİNE GİRDİ AMK2");
    }
  }
}
