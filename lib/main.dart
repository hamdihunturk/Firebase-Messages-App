// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:ilkvisual/app/landing_page.dart';
import 'package:ilkvisual/locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ilkvisual/viewmodels/usermodel.dart';
import 'package:provider/provider.dart';

void main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: ((context) => UserModel()),
      child: MaterialApp(
          title: "zdasdas",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.teal,
          ),
          home: LandingPage()),
    );
  }
}
