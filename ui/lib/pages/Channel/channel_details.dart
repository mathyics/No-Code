import 'package:flutter/material.dart';

import '../../constants/appbar.dart';
import '../../constants/routes.dart';


class ChannelDetailsPage extends StatefulWidget {
  static const route_name=channel_details;
  const ChannelDetailsPage({super.key});

  @override
  State<ChannelDetailsPage> createState() => _ChannelDetailsPageState();
}

class _ChannelDetailsPageState extends State<ChannelDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: get_app_bar('My Channel', true),
    );
  }
}
