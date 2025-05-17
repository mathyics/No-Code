import 'package:flutter/material.dart';

import '../../constants/appbar.dart';
import '../../constants/routes.dart';

class ShortsPage extends StatefulWidget {
  static const route_name=shorts_route;
  const ShortsPage({super.key});

  @override
  State<ShortsPage> createState() => _ShortsPageState();
}

class _ShortsPageState extends State<ShortsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: get_app_bar('Shorts', true),
    );
  }
}
