import 'package:flutter/material.dart';
import 'package:plproject/utils/validators.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();

  void _sendResetRequest() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement password reset logic
      print('Sending password reset request for phone: ${_phoneController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset instructions sent (simulation).')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Reset Your Password',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Enter the phone number associated with your account, and we will send instructions to reset your password.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              Text("Phone number", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              // --- REPLACED CTextField with TextFormField ---
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (val) => Validators.hasMinLength(val, 10),
                decoration: const InputDecoration(
                  hintText: "Enter your phone number",
                  counterText: "", // Hides the counter from appearing under the field
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _sendResetRequest,
                // No style needed, it will be picked up from the central theme
                child: const Text('Send Reset Instructions'),
              ),
            ],
          ), 
        ),
      ),
    );
  }
}
