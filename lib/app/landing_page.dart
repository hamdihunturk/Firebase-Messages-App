// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:ilkvisual/app/home_page.dart';
import 'package:ilkvisual/app/sign_in/sign_in_page.dart';
import 'package:ilkvisual/viewmodels/usermodel.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _usermodel = Provider.of<UserModel>(context);
    if (_usermodel.state == ViewState.Idle) {
      if (_usermodel.user == null) {
        return SignInpage();
      } else {
        return HomePage(
          user: _usermodel.user,
        );
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
