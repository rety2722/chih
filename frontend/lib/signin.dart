import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'home.dart';
import 'registration.dart';
import 'storage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final LocalAuthentication _auth = LocalAuthentication();

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

  Future<void> _loginWithBiometrics() async {
    bool authenticated = false;
    try {
      authenticated = await _auth.authenticate(
        localizedReason: 'Please authenticate to log in',
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
      );
      developer.log("${_emailController.text} auth is successful");

      if (authenticated) {
        // Retrieve the stored bearer token and navigate to HomePage
        String? token = await SecureStorage().read('bearerToken');

        if (token != null) {
          await _goToHomePage();
        } else {
          _showSnackBar(
              'No valid token found. Please log in using email and password.');
        }
      }
    } on PlatformException catch (e) {
      String email = _emailController.text;
      if (e.code == auth_error.notAvailable) {
        developer.debugger(
          when: true,
          message:
              "Biometrics is not availible on this device for user: $email",
        );
        _showSnackBar("No support for biometrics!");
      } else if (e.code == auth_error.notEnrolled) {
        developer.debugger(
          when: true,
          message: "Biometrics usage is not permitted for user: $email",
        );
        _showSnackBar("Biometrics usage is not permitted");
      } else {
        developer.debugger(
          when: true,
          message: "unkown Platform error: $e for user: $email",
        );
        _showSnackBar('Error authenticating: $e');
      }
    } catch (e) {
      developer.debugger(
        when: true,
        message: "Error: $e",
      );
      _showSnackBar('Error authenticating: $e');
    }
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
        when: true,
        message: "error saving credentials: $e",
      );
      _showSnackBar('Could not save credentials: $e');
    }
  }

  Future<void> _loginUser() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        final url = Uri.parse('http://127.0.0.1:8000/api/v1/auth/signin');
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'username': _emailController.text,
            'password': _passwordController.text,
          },
        );

        if (response.statusCode == 200) {
          // Handle successful login
          final data = jsonDecode(response.body);
          String token = data['access_token'];
          int tokenLifetime = 60 * 60; // hour in seconds

          await SecureStorage().write('bearerToken', token);
          await SecureStorage().write('tokenExpirationTime',
              _calculateExpirationTime(tokenLifetime).toString());

          if (_rememberMe) {
            await SecureStorage().write('email', _emailController.text);
            await SecureStorage().write('password', _passwordController.text);
          }

          await _goToHomePage();
        } else {
          // Handle login error
          _showSnackBar('Login failed!');
        }
      } on HttpException catch (e) {
        developer.debugger(
          when: true,
          message: "Http error: $e",
        );
        _showSnackBar("Login failed!");
      } on PlatformException catch (e) {
        developer.debugger(
          when: true,
          message: "Platform error: $e",
        );
        _showSnackBar("Login failed!");
      } catch (e) {
        developer.debugger(
          when: true,
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
  }

  Future<void> _goToRegistrationPage() async {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationPage()),
    );
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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
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
                  TextFormField(
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
                      validator: (value) => _validateEmail(value)),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Switch(
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe =
                                      value; // Toggle remember me state
                                });
                              },
                            ),
                          ),
                          const Text('Remember Me'),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          _showSnackBar('Forgot Password? (Not implemented)');
                        },
                        child: const Text('Forgot Password?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _loginUser,
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: _goToRegistrationPage,
                    child: const Text('Don\'t have an account? Register'),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: IconButton(
                      icon: const Icon(
                        Icons.fingerprint, // Use fingerprint icon
                        size: 50.0,
                        color: Colors.blue,
                      ),
                      onPressed: _loginWithBiometrics,
                      tooltip: 'Login with Biometrics',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
