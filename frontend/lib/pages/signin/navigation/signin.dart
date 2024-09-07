import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../registration.dart';

import '../../shared_functions.dart';
import '../../home/home.dart';

import '../../../core/settings.dart';
import '../../../core/api_routes.dart';
import '../../../storage.dart';

class GoToRegistrationPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  const GoToRegistrationPage({
    super.key,
    required this.formKey,
  });

  @override
  State<GoToRegistrationPage> createState() => _GoToRegistrationPageState();
}

class _GoToRegistrationPageState extends State<GoToRegistrationPage> {
  Future<void> _goToRegistrationPage() async {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
    widget.formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _goToRegistrationPage,
      child: const Text('Don\'t have an account? Register'),
    );
  }
}

class LoginUserButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController emailController;
  final TextEditingController passwordController;

  const LoginUserButton({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<LoginUserButton> createState() => _LoginUserButtonState();
}

class _LoginUserButtonState extends State<LoginUserButton> {
  Future<void> _loginUser() async {
    if (widget.formKey.currentState?.validate() ?? false) {
      try {
        final url = _composeSignInUri();
        final headers = _composeSignInHeaders();
        final body = _composeSignInBody();

        final response = await http.post(
          url,
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          _handleSuccessfulSignIn(responseBody: response.body);
        } else {
          if (!mounted) return;
          showSnackBar(context, 'Login failed!');
        }
      } catch (e) {
        developer.debugger(message: "Login Failed: ${e.toString()}");
        if (!mounted) return;
        showSnackBar(context, 'Login failed!');
      }
    }
  }

  Future<void> _saveCredentials(
    String token,
    String tokenLifetime,
    String email,
    String password,
  ) async {
    try {
      await SecureStorage().write('bearerToken', token);
      await SecureStorage().write('tokenExpirationTime', tokenLifetime);
      if (RememberMe().getRememberMeValue()) {
        await SecureStorage().write('email', email);
        await SecureStorage().write('password', password);
      }
    } catch (e) {
      developer.debugger(
        message: "error saving credentials: $e",
      );
      if (!mounted) return;
      showSnackBar(context, 'Could not save credentials: $e');
    }
  }

  int _calculateExpirationTime(int tokenLifetime) {
    return DateTime.now()
        .add(Duration(seconds: tokenLifetime))
        .millisecondsSinceEpoch;
  }

  Uri _composeSignInUri() {
    return Uri.parse('${Settings.serverAdress}${ApiRoutes.signIn}');
  }

  Map<String, String> _composeSignInHeaders() {
    return {
      'Content-Type': 'application/x-www-form-urlencoded',
    };
  }

  Map<String, String> _composeSignInBody() {
    return {
      'username': widget.emailController.text,
      'password': widget.passwordController.text,
    };
  }

  void _handleSuccessfulSignIn({required String responseBody}) async {
    final data = jsonDecode(responseBody);

    final String token = data['access_token'];
    const int tokenLifetimeInt = 60 * 60; // hour in seconds
    final String tokenLifetime =
        _calculateExpirationTime(tokenLifetimeInt).toString();
    final String email = widget.emailController.text;
    final String password = widget.emailController.text;

    await _saveCredentials(token, tokenLifetime, email, password);

    await _goToHomePage();
  }

  Future<void> _goToHomePage() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
    widget.formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _loginUser,
      child: const Text('Login'),
    );
  }
}
