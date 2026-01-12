import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sakani/generated/app_localizations.dart';
import 'package:sakani/providers/user_provider.dart';
import 'package:sakani/screens/auth/pending_approval_screen.dart';

class CompleteProfile extends StatefulWidget {
  final String phone;
  final String password;

  const CompleteProfile({super.key, required this.phone, required this.password});

  @override
  State<CompleteProfile> createState() => _CompleteProfileState();
}

class _CompleteProfileState extends State<CompleteProfile> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();

  final _picker = ImagePicker();
  XFile? _personalImageFile;
  XFile? _idCardImageFile;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _registerProfile(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_personalImageFile == null || _idCardImageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.selectBothPhotos), backgroundColor: Colors.orange),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final navigator = Navigator.of(context);

    final success = await userProvider.register(
      phone: widget.phone,
      password: widget.password,
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      dateOfBirth: _dobController.text,
      personalImage: _personalImageFile,
      idCardImage: _idCardImageFile,
    );

    if (!mounted) return;

    if (success) {
      navigator.pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PendingApprovalScreen()),
        (route) => false,
      );
    }
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
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.completeYourProfile), automaticallyImplyLeading: false),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(25),
              children: [
                Text(loc.firstName, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                TextFormField(
                  controller: _firstNameController,
                  decoration: InputDecoration(hintText: loc.enterFirstName),
                  validator: (val) => val == null || val.isEmpty ? loc.firstNameRequired : null,
                  // REMOVED inputFormatters to allow all characters
                ),
                const SizedBox(height: 15),
                Text(loc.lastName, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                TextFormField(
                  controller: _lastNameController,
                  decoration: InputDecoration(hintText: loc.enterLastName),
                  validator: (val) => val == null || val.isEmpty ? loc.lastNameRequired : null,
                  // REMOVED inputFormatters to allow all characters
                ),
                const SizedBox(height: 15),
                Text(loc.dateOfBirth, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                TextFormField(
                  controller: _dobController,
                  decoration: InputDecoration(hintText: loc.dobHint),
                  keyboardType: TextInputType.datetime,
                  // REMOVED inputFormatters to allow all characters
                ),
                const SizedBox(height: 30),
                _buildImagePicker(theme, loc.personalPhoto, _personalImageFile, () => _pickImage(true)),
                const SizedBox(height: 20),
                _buildImagePicker(theme, loc.idCardPhoto, _idCardImageFile, () => _pickImage(false)),
                const SizedBox(height: 30),
                if (userProvider.status == UserStatus.Error && userProvider.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: theme.colorScheme.error.withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      userProvider.errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: userProvider.status == UserStatus.Loading ? null : () => _registerProfile(context),
                    child: userProvider.status == UserStatus.Loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(loc.register),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme, String title, XFile? file, VoidCallback onPick) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InkWell(
          onTap: onPick,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: file == null
                ? Center(child: Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey[600]))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(11),
                    child: Image.file(File(file.path), fit: BoxFit.cover, width: double.infinity),
                  ),
          ),
        )
      ],
    );
  }
}
