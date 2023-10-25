// ignore_for_file: sort_child_properties_last, unnecessary_null_comparison, prefer_const_constructors, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'platform_duyarlwidget.dart';

class PlatformDuyarliAlert extends PlatFormDuyarli {
  final String baslik;
  final String icerik;
  final String butonyzi;
  final String iptalAksiyon;

  const PlatformDuyarliAlert(
      {super.key,
      required this.baslik,
      required this.icerik,
      required this.butonyzi,
      this.iptalAksiyon = ""});

  Future<bool?> goster(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
            context: context, builder: ((context) => this))
        : await showDialog<bool>(
            context: context,
            builder: ((context) => this),
            barrierDismissible: false);
  }

  @override
  Widget IosWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButonlari(context),
    );
  }

  @override
  // ignore: avoid_renaming_method_parameters
  Widget androidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(baslik),
      content: Text(icerik),
      actions: _dialogButonlari(context),
    );
  }

  List<Widget> _dialogButonlari(BuildContext context) {
    final tumbutonlar = <Widget>[];
    if (Platform.isIOS) {
      if (iptalAksiyon != null) {
        tumbutonlar.add(CupertinoDialogAction(
          child: Text(iptalAksiyon),
          onPressed: (() {
            Navigator.of(context).pop(false);
          }),
        ));
      }
      tumbutonlar.add(CupertinoDialogAction(
        child: Text(butonyzi),
        onPressed: (() {
          Navigator.of(context).pop(true);
        }),
      ));
    } else {
      if (iptalAksiyon != null) {
        tumbutonlar.add(TextButton(
          child: Text(iptalAksiyon),
          onPressed: (() {
            Navigator.of(context).pop(false);
          }),
        ));
      }
      tumbutonlar.add(TextButton(
          onPressed: (() {
            Navigator.of(context).pop(true);
          }),
          child: Text("Tamam")));
    }

    return tumbutonlar;
  }
}
