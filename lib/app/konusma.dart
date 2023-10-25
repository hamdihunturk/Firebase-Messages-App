import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ilkvisual/app/profilsayfasi.dart';
import 'package:ilkvisual/model/message_model.dart';
import 'package:ilkvisual/model/user.dart';
import 'package:ilkvisual/viewmodels/chat_view_model.dart';
import 'package:ilkvisual/viewmodels/usermodel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Konusma extends StatefulWidget {
  @override
  State<Konusma> createState() => _KonusmaState();
}

class _KonusmaState extends State<Konusma> {
  var _mesajCont = TextEditingController();
  ScrollController _scrollCont = ScrollController();
  bool _yukleniyor = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollCont.addListener(_listeScrollListener1);
  }

  @override
  Widget build(BuildContext context) {
    final _chatModel = Provider.of<ChatViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sohbet"),
      ),
      body: _chatModel.state == ChatViewState.Busy
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                children: [_buildMesajListesi(), _yeniMesajAt()],
              ),
            ),
    );
  }

  Widget _buildMesajListesi() {
    return Consumer<ChatViewModel>(builder: (context, value, child) {
      return Expanded(
        child: ListView.builder(
          reverse: true,
          controller: _scrollCont,
          itemBuilder: ((context, index) {
            if (value.dahaVarmii && value.mesajlarListesi!.length == index) {
              return _yeniElemanlarYukleniyorIndicator();
            } else {
              return konusmaBalonuOlustur(value.mesajlarListesi![index]);
            }
          }),
          itemCount: value.dahaVarmii
              ? value.mesajlarListesi!.length + 1
              : value.mesajlarListesi!.length,
        ),
      );
    });
  }

  Widget _yeniMesajAt() {
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);
    return Container(
      padding: const EdgeInsets.only(bottom: 8, left: 7),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _mesajCont,
              cursorColor: Colors.blueGrey,
              style: const TextStyle(fontSize: 16.0, color: Colors.black87),
              decoration: InputDecoration(
                fillColor: Colors.teal.shade300,
                filled: true, //bilgimyok
                hintText: "Mesaj yazın",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: FloatingActionButton(
              elevation: 0,
              child: const Icon(
                Icons.send,
                size: 32,
                color: Colors.white,
              ),
              onPressed: () async {
                if (_mesajCont.text.trim().length > 0) {
                  Mesaj _kaydedilecMesaj = Mesaj(
                      bendenMi: true,
                      message: _mesajCont.text,
                      kimden: _chatModel.currentUser!.userID,
                      kime: _chatModel.sohbetedilenUser!.userID);

                  var sonuc = await _chatModel.saveMessage(_kaydedilecMesaj);
                  if (sonuc) {
                    _mesajCont.clear();
                    _scrollCont.animateTo(0.0,
                        duration: const Duration(microseconds: 50),
                        curve: Curves.elasticInOut);
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget konusmaBalonuOlustur(Mesaj anlikMesaj) {
    Color gelenMesaj = Colors.blue;
    Color gidenMesaj = Theme.of(context).primaryColor;
    var _saatDakika = "";
    final _chatModel = Provider.of<ChatViewModel>(context);

    try {
      _saatDakika = saatDakikaGoster(anlikMesaj.date ?? Timestamp(1, 1));
    } catch (e) {
      print("hataaaaaaaaaaaaaaaaaaAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
    }

    bool? benimMesajMi = anlikMesaj.bendenMi;
    if (benimMesajMi!) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment
                  .end, //görüldü kısmının assada olmasını saglar
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: gidenMesaj),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(3),
                    child: Text(
                      stringNulltoString(anlikMesaj.message),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  _saatDakika,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(stringNulltoString(
                      _chatModel.sohbetedilenUser!.profilUrl)),
                ),
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: gelenMesaj),
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(3),
                    child: Text(
                      stringNulltoString(anlikMesaj.message),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  _saatDakika,
                  style: const TextStyle(fontSize: 12),
                )
              ],
            )
          ],
        ),
      );
    }
  }

  String saatDakikaGoster(Timestamp? date) {
    var _formatt = DateFormat.Hm();
    var _formatlanmisTarih = _formatt.format(date!.toDate());
    return _formatlanmisTarih;
  }

  void _listeScrollListener1() {
    if (_scrollCont.offset >= _scrollCont.position.maxScrollExtent &&
        !_scrollCont.position.outOfRange) {
      print("Listenin en üstündeyiz cünki listemiz listemiz ters gelir");
      eskiMesajlariGetir();
    }
  }

  _yeniElemanlarYukleniyorIndicator() {
    return const Padding(
      padding: EdgeInsets.all(8),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void eskiMesajlariGetir() async {
    final _chatModel = Provider.of<ChatViewModel>(context, listen: false);

    if (_yukleniyor == false) {
      print("Listener tetiklendi");
      _yukleniyor = true;

      await _chatModel.moreMessageGet();
      _yukleniyor = false;

      print("Listener tetiklendi bitti");
    } else {
      print("VOİD İCİNE GİRDİ AMK2");
    }
  }
}
