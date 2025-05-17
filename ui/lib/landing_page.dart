

import 'package:flutter/material.dart';
import 'package:no_code/pages/Channel/channel_details.dart';
import 'package:no_code/pages/Create/content_create.dart';
import 'package:no_code/pages/Home_page/home_page.dart';
import 'package:no_code/pages/Subscriptions/subscription_page.dart';
import 'package:no_code/pages/shorts_page/shorts.dart';

import 'constants/routes.dart';



class Landing_page extends StatefulWidget {
  static const String route_name = landing_route;
  const Landing_page({super.key});

  @override
  State<Landing_page> createState() => _Landing_pageState();
}

class _Landing_pageState extends State<Landing_page> {
  int currPageIdx = 0;

  void onChange(int idx) {
    setState(() {
      currPageIdx = idx;
    });
  }

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const HomePage(),
      const ShortsPage(),
      const SubscriptionPage(),
      const ContentCreatePage(),
      const ChannelDetailsPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currPageIdx],
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              navIcon(Icons.home, 0, 'Home'),
              navIcon(Icons.video_library_outlined, 1, 'Shorts'),
              const SizedBox(width: 40),
              navIcon(Icons.subscriptions_outlined, 2, 'Subscriptions'),
              navIcon(Icons.person_outline, 4, 'Channel'),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        elevation: 6,
        tooltip: 'Create Content!',
        onPressed: () {
          onChange(3); // Navigate to create page
        },
        child: const Icon(Icons.add, size: 34),
      ),
    );
  }

  Widget navIcon(IconData icon, int index, String label) {
    final isSelected = currPageIdx == index;

    return GestureDetector(
      onTap: () => onChange(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 26,
              color: isSelected ? Colors.blueAccent : Colors.grey,
            ),
            const SizedBox(height: 4),
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: isSelected
                  ? Text(
                label,
                key: ValueKey(label), // Important for AnimatedSwitcher
                style: const TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                ),
              )
                  : const SizedBox.shrink(), // empty when not selected
            ),
          ],
        ),
      ),
    );
  }

}
