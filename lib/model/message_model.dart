import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Mesaj {
  final String kimden;
  final String kime;
  final bool? bendenMi;
  final String? message;
  final Timestamp? date;
  Mesaj(
      {this.bendenMi,
      this.message,
      this.date,
      required this.kimden,
      required this.kime});

  Map<String, dynamic> toMap() {
    return {
      'kimden': kimden,
      'kime': kime,
      'bendenMi': bendenMi,
      'message': message,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  Mesaj.fromMap(Map<String, dynamic> map)
      : kimden = map['kimden'],
        kime = map['kime'],
        bendenMi = map['bendenMi'],
        //date in null gelmesi gerekiyor cünki getstream yapısı 2 kere dinliyor null gelmez ise bi şimdiki timestamp bide sonradan oluşan timestamp
        date = map['date'] /*??
            Timestamp
                .now()*/
        , //yollayan tarafta mesajın saat kısmı geç geldiği için null dönüyordu bunun icin buraya timestamp ekledim
        message = map['message'];

  @override
  String toString() {
    //return "WHO $kimden, TO WHO $kime, ME-> $bendenMi, MESSAGE $message, TİMESTAMP $date";
    return "MESSAGE $message, TİMESTAMP $date";
  }
}
