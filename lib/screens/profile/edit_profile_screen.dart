import 'package:flutter/material.dart';
import 'package:plproject/widgets/CTextField.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // Mock data controllers, pre-filled with existing user data
  final _firstNameController = TextEditingController(text: 'Yasser');
  final _lastNameController = TextEditingController(text: 'Otani');
  final _dobController = TextEditingController(text: '1990-05-15');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildProfileImage(theme),
          const SizedBox(height: 32),

          Text('First Name', style: theme.textTheme.titleMedium),
          CTextField(controller: _firstNameController, hintText: 'Your first name'),
          const SizedBox(height: 16),

          Text('Last Name', style: theme.textTheme.titleMedium),
          CTextField(controller: _lastNameController, hintText: 'Your last name'),
          const SizedBox(height: 16),

          Text('Date of Birth', style: theme.textTheme.titleMedium),
          CTextField(controller: _dobController, hintText: 'YYYY-MM-DD'),
        ],
      ),
      bottomNavigationBar: _buildSaveChangesButton(theme),
    );
  }

  Widget _buildProfileImage(ThemeData theme) {
    return Center(
      child: Stack(
        children: [
          const CircleAvatar(
            radius: 60,
            // backgroundImage: NetworkImage('...'), // Placeholder
            child: Icon(Icons.person, size: 60),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: theme.primaryColor,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                onPressed: () { /* TODO: Pick new image */ },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveChangesButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () { /* TODO: Save profile changes */ },
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
