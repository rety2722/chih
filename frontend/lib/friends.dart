import 'package:flutter/material.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  void _processGoHome() {
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _processManageEvents() async {
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
        _eventsButton(),
      ],
    );
  }

  Widget _homeButton() {
    return ElevatedButton(
      onPressed: _processGoHome,
      child: const Icon(Icons.home),
    );
  }

  Widget _eventsButton() {
    return ElevatedButton(
      onPressed: _processManageEvents,
      child: const Icon(Icons.event_available),
    );
  }
}
