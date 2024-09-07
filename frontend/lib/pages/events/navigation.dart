import 'package:flutter/material.dart';

import '../../navigation_buttons/button.dart';
import '../friends/friends.dart';

class EventsHomePageButton extends StatefulWidget {
  const EventsHomePageButton({super.key});

  @override
  State<EventsHomePageButton> createState() => _EventsHomePageButtonState();
}

class _EventsHomePageButtonState extends State<EventsHomePageButton> {
  void _processGoHome() {
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return HomePageButton(onPressed: _processGoHome);
  }
}

class EventsFriendsPageButton extends StatefulWidget {
  const EventsFriendsPageButton({super.key});

  @override
  State<EventsFriendsPageButton> createState() => _EventsFriendsPageButtonState();
}

class _EventsFriendsPageButtonState extends State<EventsFriendsPageButton> {
  Future<void> _processManageFriends() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FriendsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FriendsPageButton(onPressed: _processManageFriends);
  }
}

class EventsBottomNavigationBar extends StatefulWidget {
  const EventsBottomNavigationBar({super.key});

  @override
  State<EventsBottomNavigationBar> createState() => _EventsBottomNavigationBarState();
}

class _EventsBottomNavigationBarState extends State<EventsBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EventsHomePageButton(),
        EventsFriendsPageButton(),
      ],
    );
  }
}