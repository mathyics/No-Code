import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../controllers/auth_controllers/auth_methods.dart';
import '../models/User/user.dart';


AppBar get_app_bar(String title, bool isCenter) {
  final AuthController contr=Get.find();
  final User user=contr.user.value;
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
    centerTitle: true,
    clipBehavior: Clip.hardEdge,
    // backgroundColor: Colors.blue,
    // foregroundColor: Colors.white,
    toolbarOpacity: 1,

    actions: [
      Builder(builder: (context) {
        return IconButton(
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
            icon: CircleAvatar(
              maxRadius: 25,
              child:Image.network(user.avatar),
            ));
      }),
      SizedBox.fromSize(
        size: const Size.square(12),
      ),
    ],

  );
}
