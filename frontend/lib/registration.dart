import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'core/settings.dart';
import 'core/api_routes.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _registerUser() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
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
    } on HttpException catch (httpError) {
      developer.debugger(
        message: "Http error: ${httpError.toString()}",
      );
      _showSnackBar("Login failed!");
    } on PlatformException catch (platformError) {
      developer.debugger(
        message: "Platform error: ${platformError.toString()}",
      );
      _showSnackBar("Login failed!");
    } catch (e) {
      developer.debugger(
        message: "Unknown error: ${e.toString()}",
      );
      _showSnackBar("Login failed!");
    }
  }

  void _goToSignIn() {
    if (!mounted) return;
    Navigator.pop(context);
    _formKey.currentState?.reset();
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Uri _composeSignUpUri() {
    return Uri.parse("${Settings.serverAdress}${ApiRoutes.signUp}");
  }

  Map<String, String> _composeSignUpHeaders() {
    return {'Content-Type': 'application/json'};
  }

  String _composeSignUpBody() {
    return jsonEncode({
      'email': _emailController.text,
      'password': _passwordController.text,
      'full_name': _nameController.text,
    });
  }

  void _handleSuccessfulRegistration() {
    developer.log("${_emailController.text} has registered successfully");
    _goToSignIn();
  }

  void _handleUnsuccessfulRegistration() {
    developer.log("${_emailController.text}: registration failed");
    _showSnackBar('Oops.. Something went Wrong!');
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (value != _confirmPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chih Registration'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _nameInputField(),
                  const SizedBox(height: 16.0),
                  _emailInputField(),
                  const SizedBox(height: 16.0),
                  _passwordInputField(),
                  const SizedBox(height: 16.0),
                  _repeatPasswrodInputField(),
                  const SizedBox(height: 32.0),
                  _registerButton(),
                  const SizedBox(height: 16.0),
                  _goToSignInButton(),      
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _nameInputField() {
    return TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        labelText: 'Name',
      ),
      validator: (value) => _validateName(value),
    );
  }

  Widget _emailInputField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      validator: (value) => _validateEmail(value),
    );
  }

  Widget _passwordInputField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) => _validatePassword(value),
    );
  }

  Widget _repeatPasswrodInputField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: !_isConfirmPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        suffixIcon: IconButton(
          icon: Icon(
            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
            });
          },
        ),
      ),
      validator: (value) => _validateConfirmPassword(value),
    );
  }

  Widget _registerButton() {
    return ElevatedButton(
      onPressed: _registerUser,
      child: const Text('Register'),
    );
  }

  Widget _goToSignInButton() {
    return TextButton(
      onPressed: _goToSignIn,
      child: const Text('Already have an account? Sign In'),
    );
  }
}
