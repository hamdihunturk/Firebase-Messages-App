// ignore_for_file: prefer_const_constructors, prefer_equal_for_default_values

import 'package:flutter/material.dart';

class SocialLoginButton extends StatelessWidget {
 
  final String butonText;
  final Color butonColor;
  final Color textColor;
  final double radius;
  final double yukseklik;
  final Widget butonIcon;
  final VoidCallback onpressed;

  const SocialLoginButton(
      {Key? key,
      required this.butonText,
      this.butonColor: Colors.tealAccent,
      this.textColor: Colors.white,
      this.radius: 16,
      this.yukseklik: 40,
      required this.butonIcon,
      required this.onpressed})
      // ignore: unnecessary_null_comparison
      : assert(butonText != null, onpressed != null),
        super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        height: yukseklik,
        child: ElevatedButton(
                  style: ButtonStyle(
                    shape:MaterialStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(radius)),
                    ),) ,
                    backgroundColor: MaterialStatePropertyAll(butonColor)
                    ),
                  onPressed: onpressed,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      butonIcon,
                      Text(butonText,style: TextStyle(color: textColor),),
                      // ignore: sort_child_properties_last
                      Opacity(child: butonIcon,opacity: 0,),
                    ],
                  ),
                ),
      ),
    );
  }
}