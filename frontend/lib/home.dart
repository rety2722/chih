import 'package:flutter/material.dart';

import 'signin.dart';
import 'storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = "Guest";

  @override
  void initState() {
    super.initState();
    _loadUserName(); 
  }

  Future<void> _loadUserName() async {
    String? userName = await SecureStorage().read('email');
    if (userName != null) {
      setState(() {
        _userName = userName;
      });
      _showWelcomeSnackBar();
    }
  }

  void _showWelcomeSnackBar() {
    final snackBar = SnackBar(
      content: Text('Welcome! You\'re logged in with email: $_userName!'), 
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 32.0),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              child: const Text('Welcome! Not implemented yet! Go to login..'),
            ),
          ],
        ),
      ),
    );
  }
}
