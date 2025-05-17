
import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String msg, Color backgroundColor) {
  //the below method came from flutter-toast library we got from pub
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: backgroundColor,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
  );
}

void showErrorMsg(String message, BuildContext context) {
  //the below method we got from another-flushbar package from pub
  showFlushbar(
    context: context,
    flushbar: Flushbar(
      forwardAnimationCurve: Curves.bounceIn,
      margin: EdgeInsets.all(20),
      borderRadius: BorderRadius.circular(10),
      padding: EdgeInsets.all(20),
      flushbarPosition: FlushbarPosition.TOP,
      icon: Icon(Icons.error_outline, color: Colors.white, size: 28),
      reverseAnimationCurve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(seconds: 2),
      title: "Warning !",
      backgroundColor: Colors.red,
      message: message,
    )..show(context),
  );
}
