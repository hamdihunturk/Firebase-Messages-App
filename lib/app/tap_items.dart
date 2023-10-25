import 'package:flutter/material.dart';

// ignore: constant_identifier_names
enum TabItems { Kullanicilar, Konusmalarim, Profil }

class TabItemsData {
  final String title;
  final IconData icon;

  TabItemsData(this.title, this.icon);

  static Map<TabItems, TabItemsData> tumtablar = {
    TabItems.Kullanicilar:
        TabItemsData("kullanıcılar", Icons.supervised_user_circle),
    TabItems.Profil: TabItemsData("profil", Icons.person),
    TabItems.Konusmalarim: TabItemsData("konusmalarım", Icons.chat_bubble)
  };
}
