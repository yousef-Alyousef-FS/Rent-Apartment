import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/screens/admin/admin_dashboard_screen.dart';

class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // --- UPDATED: from email to phone ---
  final _phoneController = TextEditingController(text: '0912345678');
  final _passwordController = TextEditingController(text: 'password');

  Future<void> _login() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    // --- UPDATED: Pass phone number instead of email ---
    final success = await adminProvider.login(
      _phoneController.text,
      _passwordController.text,
    );

    if (mounted && success) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } 
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Login')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(24.0),
              shrinkWrap: true,
              children: [
                Text('Welcome, Admin', style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
                const SizedBox(height: 32),
                // --- UPDATED: TextFormField for Phone Number ---
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Phone number is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
                  validator: (v) => v!.isEmpty ? 'Password is required' : null,
                ),
                const SizedBox(height: 24),
                Consumer<AdminProvider>(
                  builder: (context, provider, child) {
                    if (provider.status == AdminStatus.Error && provider.errorMessage != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(provider.errorMessage!, style: TextStyle(color: theme.colorScheme.error), textAlign: TextAlign.center),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                ElevatedButton(
                  onPressed: Provider.of<AdminProvider>(context).status == AdminStatus.Loading ? null : _login,
                  child: Provider.of<AdminProvider>(context).status == AdminStatus.Loading
                      ? const CircularProgressIndicator()
                      : const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
