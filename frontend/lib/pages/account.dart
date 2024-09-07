import 'package:flutter/material.dart';

import '../storage.dart';
import 'signin/signin.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final String avatarUrl = 'https://via.placeholder.com/150'; // Placeholder avatar URL
  final String bio = 'This is a short bio about the user. Loves coding and exploring new technologies.';
  final List<String> friends = ['Alice', 'Bob', 'Charlie', 'David', 'Eve'];

  Future<void> _logout() async {
    await SecureStorage().deleteAll();

    // Navigate back to the SignInPage
    if (!mounted) return;
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account Page'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _logout,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Avatar
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(avatarUrl),
                ),
              ),
              const SizedBox(height: 16),
              // User Bio
              const Text(
                'Bio',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                bio,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Friends List
              const Text(
                'Friends',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(friends[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
