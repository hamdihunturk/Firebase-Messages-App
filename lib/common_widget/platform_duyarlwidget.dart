// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';

abstract class PlatFormDuyarli extends StatelessWidget {
  const PlatFormDuyarli({super.key});

  Widget androidWidget(BuildContext context);
  Widget IosWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return IosWidget(context);
    }
    return androidWidget(context);
  }
}
