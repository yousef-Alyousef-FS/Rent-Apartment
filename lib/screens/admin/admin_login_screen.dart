import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/widgets/CTextField.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _loginAdmin() {
    if (_formKey.currentState?.validate() ?? false) {
      final provider = Provider.of<AdminProvider>(context, listen: false);
      provider.login(_emailController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use a consumer to react to state changes (like loading and errors)
    return Scaffold(
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Admin Panel Login", style: theme.textTheme.headlineMedium),
                        const SizedBox(height: 24),
                        CTextField(
                          controller: _emailController,
                          hintText: "Enter your email",
                          textInputType: TextInputType.emailAddress,
                          validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email' : null,
                        ),
                        const SizedBox(height: 16),
                        CTextField(
                          controller: _passwordController,
                          hintText: "Enter your password",
                          isPassword: true,
                          validator: (value) => value == null || value.length < 8 ? 'Password must be at least 8 characters' : null,
                        ),
                        const SizedBox(height: 24),
                        // Show error message if it exists
                        if (provider.errorMessage != null && provider.status == AdminStatus.Error)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(provider.errorMessage!, style: TextStyle(color: theme.colorScheme.error)),
                          ),
                        ElevatedButton(
                          onPressed: provider.status == AdminStatus.Loading ? null : _loginAdmin,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                          ),
                          child: provider.status == AdminStatus.Loading
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text("Login"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
