import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ilkvisual/app/profilsayfasi.dart';
import 'package:ilkvisual/model/user.dart';
import 'package:provider/provider.dart';

import '../model/konusmalar.dart';
import '../viewmodels/chat_view_model.dart';
import '../viewmodels/usermodel.dart';
import 'konusma.dart';

class KonusmalarimPage extends StatefulWidget {
  const KonusmalarimPage({super.key});

  @override
  State<KonusmalarimPage> createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    UserModel _usermodel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Konusmalarim"),
      ),
      body: FutureBuilder<List<KonusmaModel>>(
        future: _usermodel.getAllConversation(_usermodel.user!.userID),
        builder: (context, konusmaListesi) {
          if (!konusmaListesi.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var tumConversation = konusmaListesi.data;
            //tumConversation da kullanıcı varsa
            if (tumConversation!.length > 0) {
              return RefreshIndicator(
                onRefresh: _konusmalarimListsiYenile,
                child: ListView.builder(
                  itemBuilder: ((context, index) {
                    var oankiKonusma = tumConversation[index];
                    return GestureDetector(
                      onTap: (() {
                        // rootNavigator: true değeri olursa tab bar gözükmüyor
                        Navigator.of(context, rootNavigator: true)
                            .push(MaterialPageRoute(
                                builder: ((context) =>
                                    // emin olmamkla birlikte çözümüm bu
                                    ChangeNotifierProvider<ChatViewModel>(
                                      create: ((context) => ChatViewModel(
                                          currentUser: _usermodel.user,
                                          sohbetedilenUser: User1.idVeResim(
                                              userID:
                                                  oankiKonusma.kimle_konusuyor!,
                                              profilUrl: oankiKonusma
                                                  .konusulanUserFoto))),
                                      child: Konusma(),
                                    ))));
                      }),
                      child: ListTile(
                        title: Text(stringNulltoString(
                            oankiKonusma.son_yollanan_mesaj)),
                        subtitle: Text(stringNulltoString(
                            //buraya ayar çekilmesi gerek
                            // ignore: prefer_interpolation_to_compose_strings
                            oankiKonusma.konusulanUserName! +
                                "                        " +
                                oankiKonusma.aradakiFark!)),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(oankiKonusma.konusulanUserFoto!),
                        ),
                      ),
                    );
                  }),
                  itemCount: tumConversation.length,
                ),
              );
            } else {
              // aslında Refresehe gerek yok
              // ben Konusmalarım tabına her bastığımda sayfa zaten yenileniyor
              // lakin şuan için kalabilir
              return RefreshIndicator(
                onRefresh: _konusmalarimListsiYenile,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height - 150,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.chat,
                            color: Theme.of(context).primaryColor,
                            size: 120,
                          ),
                          const Text(
                            "Henüz Konusma Yapılmamış",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 36),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  void _konusmalarimiGetir() async {
    final _usermodel = Provider.of<UserModel>(context);
    var sonuc = await FirebaseFirestore.instance
        .collection("konusmalar")
        .where("konusma_sahibi", isEqualTo: _usermodel.user!.userID)
        .orderBy("olusturulma_tarihi", descending: true)
        .get();

    for (var konusma in sonuc.docs) {
      // ignore: prefer_interpolation_to_compose_strings
      debugPrint("KONUSMAAA" + konusma.data().toString());
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  Future<Null> _konusmalarimListsiYenile() async {
    setState(() {});
    return null;
  }
}
