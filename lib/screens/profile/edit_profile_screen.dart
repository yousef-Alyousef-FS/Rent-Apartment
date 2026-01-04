import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/generated/app_localizations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _dobController;

  final _picker = ImagePicker();
  XFile? _newProfileImage;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserProvider>(context, listen: false).user;
    _firstNameController = TextEditingController(text: user?.firstName ?? '');
    _lastNameController = TextEditingController(text: user?.lastName ?? '');
    _dobController = TextEditingController(text: user?.birthDate ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = pickedFile;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.updateUserProfile(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      dateOfBirth: _dobController.text,
      personalImage: _newProfileImage,
    );

    if (mounted) {
      final loc = AppLocalizations.of(context)!;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.profileUpdatedSuccess), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(userProvider.errorMessage ?? loc.failedToUpdateProfile), backgroundColor: Theme.of(context).colorScheme.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.editProfile),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                _buildProfileImage(theme, userProvider.user),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(labelText: loc.firstName),
                  validator: (val) => val!.isEmpty ? loc.firstNameRequired : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(labelText: loc.lastName),
                  validator: (val) => val!.isEmpty ? loc.lastNameRequired : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(labelText: loc.dateOfBirth, hintText: loc.dobHint),
                  keyboardType: TextInputType.datetime,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildSaveChangesButton(theme, loc),
    );
  }

  Widget _buildProfileImage(ThemeData theme, User? user) {
    ImageProvider? backgroundImage;
    if (_newProfileImage != null) {
      backgroundImage = FileImage(File(_newProfileImage!.path));
    } else if (user?.profileImageUrl != null) {
      backgroundImage = NetworkImage(user!.profileImageUrl!);
    }

    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: backgroundImage,
            child: backgroundImage == null ? const Icon(Icons.person, size: 60) : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: CircleAvatar(
              radius: 20,
              backgroundColor: theme.primaryColor,
              child: IconButton(
                icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                onPressed: _pickImage,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveChangesButton(ThemeData theme, AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Consumer<UserProvider>(
        builder: (context, provider, child) {
          return ElevatedButton(
            onPressed: provider.status == UserStatus.Loading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: provider.status == UserStatus.Loading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(loc.saveChanges),
          );
        },
      ),
    );
  }
}
