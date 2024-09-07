import 'package:flutter/material.dart';

import 'background_map.dart';
import 'navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final backgroundMap = const BackgroundMap();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            backgroundMap,
            const Positioned(
              top: 40,
              left: 16,
              child: CurrentCityBox(),
            ),
            const Positioned(
              top: 40,
              right: 16,
              child: HomeAccountPageButton(),
            ),
            const Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: HomeBottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }
}
