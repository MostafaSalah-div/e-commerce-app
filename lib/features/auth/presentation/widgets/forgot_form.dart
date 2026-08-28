import 'package:flutter/material.dart';

class ForgotForm extends StatefulWidget {
  final void Function(String email) onSubmit;
  const ForgotForm({super.key, required this.onSubmit});

  @override
  State<ForgotForm> createState() => _ForgotFormState();
}

class _ForgotFormState extends State<ForgotForm> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Enter email' : null,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                widget.onSubmit(_emailController.text.trim());
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }
}
