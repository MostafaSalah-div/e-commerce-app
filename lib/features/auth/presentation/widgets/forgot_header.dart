import 'package:flutter/material.dart';

class ForgotHeader extends StatelessWidget {
  const ForgotHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 32),
        Text(
          'Enter your email to reset your password',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
