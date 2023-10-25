// ignore_for_file: invalid_required_positional_param

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User1 {
  final String userID;
  String? email;
  String? userName;
  String? profilUrl;
  DateTime? createAt;
  DateTime? updatedAt;
  int? seviye;

  User1({Key? key, required this.userID, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'email': email,
      'userName': userName ??
          email!.substring(0, email!.indexOf('@')) + randomSayiUret(),
      'profilUrl': profilUrl ?? "https://picsum.photos/250?image=9",
      'createAt': createAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  User1.fromMap(Map<String, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilUrl = map['profilUrl'],
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        createAt = (map['createAt'] as Timestamp).toDate(),
        seviye = map['seviye'];
  User1.idVeResim({Key? key, required this.userID, required this.profilUrl});

  @override
  String toString() {
    return "UserID $userID , email $email ,  updatedAt $updatedAt , username $userName";
  }

  String randomSayiUret() {
    int random = Random().nextInt(9999999);
    return random.toString();
  }
}
