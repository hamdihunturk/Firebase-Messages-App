// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';

class OrnekPage2 extends StatelessWidget {
  const OrnekPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ornke page"),
      ),
      body: Center(
          child: Container(
              child: Image.network(
                  'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif'))),
    );
  }
}
