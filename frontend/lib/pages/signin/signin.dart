import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:frontend/pages/signin/input_fields.dart';
import 'package:frontend/pages/signin/navigation/signin.dart';

import '../../storage.dart';
import '../shared_functions.dart';
import 'other_buttons.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  late PasswordInputField passwordInputField;
  late EmailInputField emailInputField;
  final RememberMeButton rememberMeButton = const RememberMeButton();

  late LoginUserButton loginUserButton;
  late GoToRegistrationPage goToRegistrationPage;

  @override
  void initState() {
    passwordInputField = PasswordInputField();
    emailInputField = EmailInputField(
      nextFocusNode: passwordInputField.focusNode,
    );

    loginUserButton = LoginUserButton(
      formKey: _formKey,
      emailController: emailInputField.controller,
      passwordController: passwordInputField.controller,
    );

    goToRegistrationPage = GoToRegistrationPage(
      formKey: _formKey,
    );
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
        emailInputField.controller.text = email;
        emailInputField.controller.text = password;
        RememberMe().setRememberMe(rememberMe);
      });
    } catch (e) {
      developer.debugger(
        message: "error loading saved credentials: $e",
      );
      if (!mounted) return;
      showSnackBar(context, 'Could not load saved credentials: $e');
    }
  }

  // @override
  // void dispose() {
  //   super.dispose();

  //   emailInputField.controller.dispose();
  //   passwordInputField.controller.dispose();
  // }

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
                  emailInputField,
                  const SizedBox(height: 16.0),
                  passwordInputField,
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      rememberMeButton,
                      const ForgotPasswordButton(),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  loginUserButton,
                  const SizedBox(height: 16.0),
                  goToRegistrationPage,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
