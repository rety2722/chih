import 'package:flutter/material.dart';
import 'package:frontend/pages/signin/navigation/registration.dart';

import 'input_fields.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  late ConfirmPasswordInputField confirmPasswordInputField;
  late PasswordInputField passwordInputField;
  late EmailInputField emailInputField;
  late NameInputField nameInputField;

  late RegisterUserButton registerUserButton;
  late GoToLoginPage goToLoginPage;

  @override
  void initState() {
    super.initState();

    passwordInputField = PasswordInputField(
      registrationMode: true,
    );
    confirmPasswordInputField = ConfirmPasswordInputField(
      passwordController: passwordInputField.controller,
    );
    emailInputField = EmailInputField(
      nextFocusNode: passwordInputField.focusNode,
    );
    nameInputField = NameInputField(
      nextFocusNode: emailInputField.focusNode,
    );

    registerUserButton = RegisterUserButton(
      formKey: _formKey,
      nameController: nameInputField.controller,
      emailController: emailInputField.controller,
      passwordController: passwordInputField.controller,
    );

    goToLoginPage = GoToLoginPage(formKey: _formKey);
  }

  @override
  void dispose() {
    super.dispose();
    
    nameInputField.controller.dispose();
    emailInputField.controller.dispose();
    passwordInputField.controller.dispose();
    confirmPasswordInputField.controller.dispose();
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
                  nameInputField,
                  const SizedBox(height: 16.0),
                  emailInputField,
                  const SizedBox(height: 16.0),
                  passwordInputField,
                  const SizedBox(height: 16.0),
                  confirmPasswordInputField,
                  const SizedBox(height: 32.0),
                  registerUserButton,
                  const SizedBox(height: 16.0),
                  goToLoginPage,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
