import 'package:flutter/material.dart';

import '../../storage.dart';
import '../shared_functions.dart';

class RememberMeButton extends StatefulWidget {
  const RememberMeButton({super.key});

  @override
  State<RememberMeButton> createState() => _RememberMeButtonState();
}

class _RememberMeButtonState extends State<RememberMeButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: RememberMe().getRememberMeValue(),
            onChanged: (value) {
              setState(() {
                RememberMe().setRememberMe(value);
              });
            },
          ),
        ),
        const Text('Remember Me'),
      ],
    );
  }
}

class ForgotPasswordButton extends StatefulWidget {
  const ForgotPasswordButton({super.key});

  @override
  State<ForgotPasswordButton> createState() => _ForgotPasswordButtonState();
}

class _ForgotPasswordButtonState extends State<ForgotPasswordButton> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (!mounted) return;
        showSnackBar(context, 'Forgot Password? (Not implemented)');
      },
      child: const Text('Forgot Password?'),
    );
  }
}