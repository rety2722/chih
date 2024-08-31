import 'package:flutter/material.dart';

import 'friends.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  void _processGoHome() {
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _processManageFriends() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FriendsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Scaffold(),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: _bottomNavigationBar(),
        ),
      ],
    );
  }

  Widget _bottomNavigationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _homeButton(),
        _friendsButton(),
      ],
    );
  }

  Widget _homeButton() {
    return ElevatedButton(
      onPressed: _processGoHome,
      child: const Icon(Icons.home),
    );
  }

  Widget _friendsButton() {
    return ElevatedButton(
      onPressed: _processManageFriends,
      child: const Icon(Icons.person_add),
    );
  }
}
