// ignore_for_file: file_names

import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'ornek_page2.dart';

class OrnekPage1 extends StatelessWidget {
  const OrnekPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ornke page"),
        actions: [
          IconButton(
              onPressed: (() {
                Navigator.of(
                  context, /*rootNavigator: true /*alttaki barı yok eder*/*/
                ).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: ((context) => OrnekPage2())));
              }),
              icon: Icon(Icons.add))
        ],
      ),
      body: Center(child: Container(child: CircularProgressIndicator())),
    );
  }
}
