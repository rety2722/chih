import 'package:flutter/material.dart';

import '../account.dart';
import '../friends/friends.dart';
import '../events/events.dart';

import '../../navigation_buttons/button.dart';

class HomeBottomNavigationBar extends StatefulWidget {
  const HomeBottomNavigationBar({super.key});

  @override
  State<HomeBottomNavigationBar> createState() =>
      _HomeBottomNavigationBarState();
}

class _HomeBottomNavigationBarState extends State<HomeBottomNavigationBar> {
  Future<void> _processManageEvents() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EventsPage()),
    );
  }

  Future<void> _processManageFriends() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FriendsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SearchPageButton(),
        EventsPageButton(onPressed: _processManageEvents),
        FriendsPageButton(onPressed: _processManageFriends),
      ],
    );
  }
}

class HomeAccountPageButton extends StatefulWidget {
  const HomeAccountPageButton({super.key});

  @override
  State<HomeAccountPageButton> createState() => _HomeAccountPageButtonState();
}

class _HomeAccountPageButtonState extends State<HomeAccountPageButton> {
  Future<void> _navigateToAccountPage() async {
    if (!mounted) return;
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AccountPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AccountPageButton(onPressed: _navigateToAccountPage);
  }
}
