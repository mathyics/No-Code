import 'package:flutter/material.dart';

import '../../constants/appbar.dart';
import '../../constants/routes.dart';

class ContentCreatePage extends StatefulWidget {
  static const route_name=content_create_route;
  const ContentCreatePage({super.key});

  @override
  State<ContentCreatePage> createState() => _ContentCreatePageState();
}

class _ContentCreatePageState extends State<ContentCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: get_app_bar('Content creation', true),
    );
  }
}
