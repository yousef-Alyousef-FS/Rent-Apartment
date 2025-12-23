import 'package:flutter/material.dart';
import 'package:plproject/widgets/CTextField.dart';

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
            CTextField(
              controller: _currentPasswordController,
              hintText: 'Current Password',
              isPassword: true,
            ),
            const SizedBox(height: 16),
            CTextField(
              controller: _newPasswordController,
              hintText: 'New Password',
              isPassword: true,
            ),
            const SizedBox(height: 16),
            CTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirm New Password',
              isPassword: true,
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
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: const Text('Save Changes'),
      ),
    );
  }
}
