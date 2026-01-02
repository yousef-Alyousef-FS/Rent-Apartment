import 'package:flutter/material.dart';
// import 'package:plproject/widgets/CTextField.dart'; // No longer needed

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            Text("Current Password", style: theme.textTheme.titleMedium),
            // --- REPLACED CTextField with TextFormField ---
            TextFormField(
              controller: _currentPasswordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Enter your current password'),
            ),
            const SizedBox(height: 24),

            Text("New Password", style: theme.textTheme.titleMedium),
            // --- REPLACED CTextField with TextFormField ---
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Enter your new password'),
            ),
            const SizedBox(height: 16),

            Text("Confirm New Password", style: theme.textTheme.titleMedium),
            // --- REPLACED CTextField with TextFormField ---
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Re-enter your new password'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveChangesButton(theme),
    );
  }

  Widget _buildSaveChangesButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () { /* TODO: Change password logic */ },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
        ),
        child: const Text('Save Changes'),
      ),
    );
  }
}
