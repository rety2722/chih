import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 30.0, // Default size
  });

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(widget.icon, size: widget.size),
      onPressed: widget.onPressed,
    );
  }
}

class AccountPageButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AccountPageButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<AccountPageButton> createState() => _AccountPageButtonState();
}

class _AccountPageButtonState extends State<AccountPageButton> {
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: Icons.account_circle,
      onPressed: widget.onPressed,
      size: 30.0,
    );
  }
}

class FriendsPageButton extends StatefulWidget {
  final VoidCallback onPressed;

  const FriendsPageButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<FriendsPageButton> createState() => _FriendsPageButtonState();
}

class _FriendsPageButtonState extends State<FriendsPageButton> {
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: Icons.person_add,
      onPressed: widget.onPressed,
      size: 30.0,
    );
  }
}

class EventsPageButton extends StatefulWidget {
  final VoidCallback onPressed;

  const EventsPageButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<EventsPageButton> createState() => _EventsPageButtonState();
}

class _EventsPageButtonState extends State<EventsPageButton> {
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: Icons.event,
      onPressed: widget.onPressed,
      size: 30.0,
    );
  }
}

class SearchPageButton extends StatefulWidget {
  const SearchPageButton({
    super.key,
  });

  @override
  State<SearchPageButton> createState() => _SearchPageButtonState();
}

class _SearchPageButtonState extends State<SearchPageButton> {
  void _processSearch() {
    //TODO() сделать поиск
  }

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: Icons.search,
      onPressed: _processSearch,
      size: 30.0,
    );
  }
}

class HomePageButton extends StatefulWidget {
  final VoidCallback onPressed;

  const HomePageButton({
    super.key,
    required this.onPressed,
  });

  @override
  State<HomePageButton> createState() => _HomePageButtonState();
}

class _HomePageButtonState extends State<HomePageButton> {
  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      icon: Icons.home,
      onPressed: widget.onPressed,
      size: 30.0,
    );
  }
}
