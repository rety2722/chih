import 'package:flutter/material.dart';
import 'storage.dart';

import 'pages/signin/signin.dart';
import 'pages/home/home.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      title: 'Chih',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<Widget>(
        future: _getInitialPage(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return snapshot.data!; // Navigate to the appropriate page
          } else {
            return Container(); // Handle error case
          }
        },
      ),
    );
  }

  Future<Widget> _getInitialPage() async {
    String? token = await SecureStorage().read('bearerToken');
    String? expirationTimeString =
        await SecureStorage().read('tokenExpirationTime');
    int? expirationTime =
        expirationTimeString != null ? int.parse(expirationTimeString) : null;

    if (token != null &&
        expirationTime != null &&
        expirationTime > DateTime.now().millisecondsSinceEpoch) {
      return const HomePage(); // Navigate to HomePage if token is valid
    } else {
      return const LoginPage(); // Show LoginPage if no valid token
    }
  }
}
