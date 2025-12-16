import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/providers/auth_provider.dart';
import 'package:plproject/services/storage_service.dart';
import '../../widgets/CTextField.dart';

class CompleteProfile extends StatefulWidget {
  const CompleteProfile({super.key});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();

  final _storageService = StorageService();
  final _picker = ImagePicker();

  // State variables to hold the chosen image files
  XFile? _personalImageFile;
  XFile? _idCardImageFile;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _submitProfile() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? personalImageUrl;
    String? idCardImageUrl;

    // Check if user and token exist before proceeding
    final userId = authProvider.user?.id;
    if (userId == null) {
      // Show an error, this should not happen in a normal flow
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: User not found!")));
      return;
    }

    // 1. Upload images if they have been picked
    if (_personalImageFile != null) {
      personalImageUrl = await _storageService.uploadImage(_personalImageFile!.path, 'profile_images/$userId.jpg');
    }
    if (_idCardImageFile != null) {
      idCardImageUrl = await _storageService.uploadImage(_idCardImageFile!.path, 'id_cards/$userId.jpg');
    }

    // 2. Create the User object with all the data
    final userToUpdate = User(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      dateOfBirth: DateTime.tryParse(_dobController.text),
      personalImagePath: personalImageUrl,
      idCardImagePath: idCardImageUrl,
    );

    // 3. Call the provider to update the profile
    await authProvider.updateProfile(userToUpdate);
  }

  Future<void> _pickImage(bool isPersonal) async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        if (isPersonal) {
          _personalImageFile = pickedFile;
        } else {
          _idCardImageFile = pickedFile;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Your Profile"), automaticallyImplyLeading: false),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(25),
            children: [
              Text("Personal Information", style: theme.textTheme.displaySmall, textAlign: TextAlign.center),
              Text("Fill your information to continue...", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 30),
              
              Text("First Name", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              CTextField(controller: _firstNameController, hintText: "Enter your first name"),
              const SizedBox(height: 15),
              
              Text("Last Name", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              CTextField(controller: _lastNameController, hintText: "Enter your last name"),
              const SizedBox(height: 15),

              Text("Date Of Birth", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
              CTextField(controller: _dobController, hintText: "YYYY-MM-DD"),
              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildUploadButton(theme, icon: Icons.camera_alt_outlined, label: "Personal Image", imageFile: _personalImageFile, onTap: () => _pickImage(true)),
                  _buildUploadButton(theme, icon: Icons.credit_card_outlined, label: "ID Card Image", imageFile: _idCardImageFile, onTap: () => _pickImage(false)),
                ],
              ),
              const SizedBox(height: 30),

              MaterialButton(
                onPressed: authProvider.authStatus == AuthStatus.Authenticating ? null : _submitProfile,
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(25)),
                  child: authProvider.authStatus == AuthStatus.Authenticating
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Submit", style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.onPrimary)),
                ),
              ),
              
              if (authProvider.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(authProvider.errorMessage!, style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUploadButton(ThemeData theme, {required IconData icon, required String label, XFile? imageFile, required VoidCallback onTap}) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: 130, height: 100,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: theme.dividerColor, width: 1.5),
            ),
            // Display the picked image, otherwise show the icon
            child: imageFile != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.file(File(imageFile.path), fit: BoxFit.cover, width: double.infinity, height: double.infinity,)
                  )
                : Icon(icon, color: theme.colorScheme.primary, size: 50),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center),
      ],
    );
  }
}
