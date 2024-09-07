import 'package:flutter/material.dart';

import 'navigation.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: const Text('Events Page'),
              automaticallyImplyLeading: false,
            ),
          ),
          const Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: EventsBottomNavigationBar(),
          ),
        ],
      ),
    );
  }
}
