import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../shared_functions.dart';

import '../../../core/settings.dart';
import '../../../core/api_routes.dart';

class GoToLoginPage extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const GoToLoginPage({
    super.key,
    required this.formKey,
  });

  @override
  State<GoToLoginPage> createState() => _GoToLoginPageState();
}

class _GoToLoginPageState extends State<GoToLoginPage> {
  void _goToSignIn() {
    if (!mounted) return;
    Navigator.pop(context);
    widget.formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: _goToSignIn,
      child: const Text('Already have an account? Sign In'),
    );
  }
}

class RegisterUserButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  const RegisterUserButton({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
  });

  @override
  State<RegisterUserButton> createState() => _RegisterUserButtonState();
}

class _RegisterUserButtonState extends State<RegisterUserButton> {
  Future<void> _registerUser() async {
    try {
      if (widget.formKey.currentState?.validate() ?? false) {
        final url = _composeSignUpUri();
        final headers = _composeSignUpHeaders();
        final body = _composeSignUpBody();

        final response = await http.post(
          url,
          headers: headers,
          body: body,
        );

        if (response.statusCode == 200) {
          _handleSuccessfulRegistration();
        } else {
          _handleUnsuccessfulRegistration();
        }
      }
    } catch (e) {
      developer.debugger(
        message: "Registration Failed: ${e.toString()}",
      );
      if (!mounted) return;
      showSnackBar(context, "Login failed!");
    }
  }

  Uri _composeSignUpUri() {
    return Uri.parse("${Settings.serverAdress}${ApiRoutes.signUp}");
  }

  Map<String, String> _composeSignUpHeaders() {
    return {'Content-Type': 'application/json'};
  }

  String _composeSignUpBody() {
    return jsonEncode({
      'email': widget.emailController.text,
      'password': widget.passwordController.text,
      'full_name': widget.nameController.text,
    });
  }

  void _handleSuccessfulRegistration() {
    developer.log(
      "${widget.emailController.text} has registered successfully",
    );
    _goToSignIn();
  }

  void _handleUnsuccessfulRegistration() {
    developer.log(
      "${widget.emailController.text}: registration failed",
    );
    if (!mounted) return;
    showSnackBar(context, 'Oops.. Something went Wrong!');
  }

  void _goToSignIn() {
    if (!mounted) return;
    Navigator.pop(context);
    widget.formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _registerUser,
      child: const Text('Register'),
    );
  }
}
