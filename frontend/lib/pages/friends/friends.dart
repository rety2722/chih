import 'package:flutter/material.dart';

import 'navigation.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
            Scaffold(
              appBar: AppBar(
                title: const Text('Friends page'),
                automaticallyImplyLeading: false,
              ),
            ),
            const Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: FriendsBottomNavigationBar(),
          ),
        ],
      ),
    );
  }
}
