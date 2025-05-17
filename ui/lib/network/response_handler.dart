import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../Utils/show_toast.dart';

class ResponseHandler {
  static bool is_good_response(
    Response res,
    BuildContext context,
  ) {
    if (res.statusCode != 200) {
      var err=extractErrorMessage(res.body);
      showErrorMsg(err, context);
      log(err);
      return false;
    }
    showToast(jsonDecode(res.body)['message'], Colors.green);
    return true;
  }

  static String extractErrorMessage(String html) {
  final RegExp errorRegex = RegExp(r'<pre>Error: (.*?)<br>', dotAll: true);
  final match = errorRegex.firstMatch(html);
  return match != null ? match.group(1) ?? "An error occurred" : "An error occurred";
}
}
