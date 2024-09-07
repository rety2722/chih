import 'package:flutter/material.dart';

class StatefulInputField extends StatefulWidget {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final FocusNode? nextFocusNode;

  StatefulInputField({
    super.key,
    this.nextFocusNode,
  });

  String? validateInput(String? value) {
    return null;
  }

  @override
  State<StatefulInputField> createState() => _StatefulInputFieldState();
}

class _StatefulInputFieldState extends State<StatefulInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField();
  }
}

class NameInputField extends StatefulInputField {
  NameInputField({
    super.key,
    super.nextFocusNode,
  });

  @override
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  @override
  State<NameInputField> createState() => _NameInputFieldState();
}

class _NameInputFieldState extends State<NameInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: const InputDecoration(
        labelText: 'Name',
      ),
      keyboardType: TextInputType.name,
      textInputAction:
          widget.nextFocusNode == null ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: (_) {
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      validator: (value) => widget.validateInput(value),
    );
  }
}

class EmailInputField extends StatefulInputField {
  EmailInputField({
    super.key,
    super.nextFocusNode,
  });

  @override
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  State<EmailInputField> createState() => _EmailInputFieldState();
}

class _EmailInputFieldState extends State<EmailInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      decoration: const InputDecoration(
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction:
          widget.nextFocusNode == null ? TextInputAction.done : TextInputAction.next,
      onFieldSubmitted: (_) {
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      validator: (value) => widget.validateInput(value),
    );
  }
}

class PasswordInputField extends StatefulInputField {
  final bool registrationMode;

  PasswordInputField({
    super.key,
    super.nextFocusNode,
    this.registrationMode = false,
  });

  @override
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    // Handle Registration
    if (registrationMode && value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  @override
  State<PasswordInputField> createState() => _PasswordInputFieldState();
}

class _PasswordInputFieldState extends State<PasswordInputField> {
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: !isPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              isPasswordVisible = !isPasswordVisible;
            });
          },
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: widget.nextFocusNode == null
          ? TextInputAction.done
          : TextInputAction.next,
      onFieldSubmitted: (_) {
        if (widget.nextFocusNode != null) {
          FocusScope.of(context).requestFocus(widget.nextFocusNode);
        }
      },
      validator: widget.validateInput,
    );
  }
}

class ConfirmPasswordInputField extends StatefulInputField {
  final TextEditingController passwordController;

  ConfirmPasswordInputField({
    super.key,
    super.nextFocusNode,
    required this.passwordController,
  });

  @override
  String? validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  State<ConfirmPasswordInputField> createState() =>
      _ConfirmPasswordInputFieldState();
}

class _ConfirmPasswordInputFieldState extends State<ConfirmPasswordInputField> {
  bool isConfirmPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: !isConfirmPasswordVisible,
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        suffixIcon: IconButton(
          icon: Icon(
            isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              isConfirmPasswordVisible = !isConfirmPasswordVisible;
            });
          },
        ),
      ),
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      validator: (value) => widget.validateInput(value),
    );
  }
}
