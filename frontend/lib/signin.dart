import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'home.dart';
import 'registration.dart';
import 'storage.dart';
import 'core/api_routes.dart';
import 'core/settings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    try {
      String email = await SecureStorage().read('email') ?? '';
      String password = await SecureStorage().read('password') ?? '';
      String rememberMeString =
          await SecureStorage().read('rememberMe') ?? 'false';
      bool rememberMe = (rememberMeString == 'true');

      setState(() {
        _emailController.text = email;
        _passwordController.text = password;
        _rememberMe = rememberMe;
      });
    } catch (e) {
      developer.debugger(
        message: "error loading saved credentials: $e",
      );
      _showSnackBar('Could not load saved credentials: $e');
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
      if (_rememberMe) {
        await SecureStorage().write('email', email);
        await SecureStorage().write('password', password);
      }
    } catch (e) {
      developer.debugger(
        message: "error saving credentials: $e",
      );
      _showSnackBar('Could not save credentials: $e');
    }
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
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
          _showSnackBar('Login failed!');
        }
      } on PlatformException catch (e) {
        developer.debugger(
          message: "Platform error: $e",
        );
        _showSnackBar("Login failed!");
      } catch (e) {
        developer.debugger(
          message: "Unknown error: $e",
        );
        _showSnackBar("Login failed!");
      }
    }
  }

  Future<void> _goToHomePage() async {
    if (!mounted) return;
    await Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
    _formKey.currentState?.reset();
  }

  Future<void> _goToRegistrationPage() async {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
    _formKey.currentState?.reset();
  }

  void _showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      'username': _emailController.text,
      'password': _passwordController.text,
    };
  }

  void _handleSuccessfulSignIn({required String responseBody}) async {
    final data = jsonDecode(responseBody);

    final String token = data['access_token'];
    const int tokenLifetimeInt = 60 * 60; // hour in seconds
    final String tokenLifetime =
        _calculateExpirationTime(tokenLifetimeInt).toString();
    final String email = _emailController.text;
    final String password = _passwordController.text;

    await _saveCredentials(token, tokenLifetime, email, password);

    await _goToHomePage();
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
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
                  _emailInputField(),
                  const SizedBox(height: 16.0),
                  _passwordInputField(),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _remmeberMeSlider(),
                      _forgotPasswordButton(),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  _loginUserButton(),
                  const SizedBox(height: 16.0),
                  _goToRegistrationPageButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _emailInputField() {
    return TextFormField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_passwordFocusNode);
      },
      validator: (value) => _validateEmail(value),
    );
  }

  Widget _passwordInputField() {
    return TextFormField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
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
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      validator: _validatePassword,
    );
  }

  Widget _remmeberMeSlider() {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: _rememberMe,
            onChanged: (value) {
              setState(() {
                _rememberMe = value; // Toggle remember me state
              });
            },
          ),
        ),
        const Text('Remember Me'),
      ],
    );
  }

  Widget _forgotPasswordButton() {
    return TextButton(
      onPressed: () {
        _showSnackBar('Forgot Password? (Not implemented)');
      },
      child: const Text('Forgot Password?'),
    );
  }

  Widget _loginUserButton() {
    return ElevatedButton(
      onPressed: _loginUser,
      child: const Text('Login'),
    );
  }

  Widget _goToRegistrationPageButton() {
    return TextButton(
      onPressed: _goToRegistrationPage,
      child: const Text('Don\'t have an account? Register'),
    );
  }
}
