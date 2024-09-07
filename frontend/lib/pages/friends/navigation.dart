import 'package:flutter/material.dart';

import '../../navigation_buttons/button.dart';
import '../events/events.dart';

class FriendsHomePageButton extends StatefulWidget {
  const FriendsHomePageButton({super.key});

  @override
  State<FriendsHomePageButton> createState() => _FriendsHomePageButtonState();
}

class _FriendsHomePageButtonState extends State<FriendsHomePageButton> {
  void _processGoHome() {
    if (!mounted) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return HomePageButton(onPressed: _processGoHome);
  }
}

class FriendsEventsPageButton extends StatefulWidget {
  const FriendsEventsPageButton({super.key});

  @override
  State<FriendsEventsPageButton> createState() => _FriendsEventsPageButtonState();
}

class _FriendsEventsPageButtonState extends State<FriendsEventsPageButton> {
  Future<void> _processManageEvents() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const EventsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return EventsPageButton(onPressed: _processManageEvents);
  }
}

class FriendsBottomNavigationBar extends StatefulWidget {
  const FriendsBottomNavigationBar({super.key});

  @override
  State<FriendsBottomNavigationBar> createState() => _FriendsBottomNavigationBarState();
}

class _FriendsBottomNavigationBarState extends State<FriendsBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FriendsHomePageButton(),
        FriendsEventsPageButton(),
      ],
    );
  }
}
