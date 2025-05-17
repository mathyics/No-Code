import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

import '../Utils/show_toast.dart';

class HttpExceptionHandler{
  static void handle(Exception error, BuildContext context) {
    if (error is SocketException) {
      showErrorMsg("No Internet connection!", context);
    } else if (error is TimeoutException) {
      showErrorMsg("Server timed out!", context);
    } else {
      log("Unknown error: $error");
      showErrorMsg("Something went wrong!", context);
    }
    throw Exception(error.toString());
  }


}
