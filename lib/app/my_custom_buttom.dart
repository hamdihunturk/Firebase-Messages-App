import 'package:flutter/cupertino.dart';
import 'package:ilkvisual/app/tap_items.dart';

class MyCustomButtomNavigator extends StatelessWidget {
  final TabItems currentTab;
  final ValueChanged<TabItems> onSelecedTab;
  final Map<TabItems, dynamic> sayfaOlusturucu;
  final Map<TabItems, GlobalKey<NavigatorState>> navigatorKeys;

  ///???? dynamic sonradan eklendi widget iken hata aldım nedenini çözemedim

  const MyCustomButtomNavigator(
      {super.key,
      required this.currentTab,
      required this.onSelecedTab,
      required this.sayfaOlusturucu,
      required this.navigatorKeys});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          _navItemOlus(TabItems.Kullanicilar),
          _navItemOlus(TabItems.Konusmalarim),
          _navItemOlus(TabItems.Profil),
        ],
        onTap: ((value) => onSelecedTab(TabItems.values[value])),
      ),
      tabBuilder: ((context, index) {
        final gosterilecekItem = TabItems.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[gosterilecekItem],
          builder: (context) {
            return sayfaOlusturucu[gosterilecekItem];
          },
        );
      }),
    );
  }

  BottomNavigationBarItem _navItemOlus(TabItems tabItems) {
    final olusturulacakTab = TabItemsData.tumtablar[tabItems];

    return BottomNavigationBarItem(
        icon: Icon(olusturulacakTab?.icon),
        label: '${olusturulacakTab?.title}');
  }
}
