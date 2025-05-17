import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:no_code/constants/routes.dart';

import '../Utils/button.dart';
import '../controllers/auth_controllers/auth_methods.dart';
import '../pages/Profile_Page/profile_page.dart';
import '../pages/Settings/settings_page.dart';

Widget get_end_drawer(BuildContext context) {
  final Map<String, Widget> routeMap = {
    'Profile': const ProfilePage(),
    'Settings': const SettingsPage(),
  };
  final AuthController authController =Get.find();
  final user=authController.user.value;
  return SafeArea(
    child: Drawer(
      elevation: 16.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: const AlignmentDirectional(1.0, -1.0),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Align(
                alignment: const AlignmentDirectional(1.0, -1.0),
                child: Padding(
                  padding: const EdgeInsets.all(22.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Text(
                          user.userName,
                          style: const TextStyle(
                              fontFamily: 'Inter', fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      CircleAvatar(
                        child: Icon(Icons.person), // Adjust radius as needed
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: routeMap.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (_, idx) {
                  String title = routeMap.keys.elementAt(idx);
                  Widget toNavigate = routeMap.values.elementAt(idx);
                  return listTile(
                      con: context, title: title, toNavigate: toNavigate);
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 34),
            child: MyButton(
              buttonTitle: 'Logout',
              isLoading: false,
              onPressed: () async {
                //logout fn
                bool logoutSuccess=await authController.logout(context);
                if(logoutSuccess)Navigator.of(context).pushReplacementNamed(login_route);
              },
              btnColor: Colors.red,
            ),
          ),
        ],
      ),
    ),
  );
}

ListTile listTile(
    {required BuildContext con,
    required String title,
    String subtitle = '',
    Widget? toNavigate}) {
  return ListTile(
    title: Text(title, style: const TextStyle(fontFamily: 'Inter')),
    trailing: IconButton(
      icon: const Icon(Icons.arrow_forward_ios_rounded),
      color: Colors.red,
      onPressed: () {
        Navigator.of(con).push(MaterialPageRoute(builder: (_) => toNavigate!));
      },
    ),
    tileColor: Colors.white54,
    dense: false,
    contentPadding: const EdgeInsets.all(10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
  );
}
