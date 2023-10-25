import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ilkvisual/model/konusmalar.dart';

import '../model/message_model.dart';
import '../model/user.dart';

abstract class DBbase {
  Future<bool> saveUser(User1 user1);
  Future<User1> readUser(String userID);
  Future<bool> updateUserName(String userID, String yeniUsername);
  Future<bool> updateProfilFoto(String userID, String profilFotoURL);
  Future<List<User1>?> getAllUsers();
  Future<List<User1>> getUsersWithPagination(
      User1? lastgetUser, int getirilecekElemanSayisi);
  Future<List<KonusmaModel>> getAllConversation(String userID);
  Stream<List<Mesaj>> getMassage(String currentUSer, String karsiTarafId);
  Future<bool> saveMessage(Mesaj kaydedilecMesaj);
  Future<DateTime> saatiGoster(String userID);
}
