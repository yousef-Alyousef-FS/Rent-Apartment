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
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();

  final _storageService = StorageService();
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

  Future<void> _registerProfile() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    String? personalImageUrl;
    String? idCardImageUrl;

    try {
      authProvider.setAuthenticating(); // Set loading state

      if (_personalImageFile != null) {
        personalImageUrl = await _storageService.uploadImage(_personalImageFile!.path);
      }
      if (_idCardImageFile != null) {
        idCardImageUrl = await _storageService.uploadImage(_idCardImageFile!.path);
      }

      final profileData = User(
        first_name: _firstNameController.text,
        last_name: _lastNameController.text,
        dateOfBirth: DateTime.tryParse(_dobController.text),
        profile_image: personalImageUrl,
        id_card_image: idCardImageUrl,
      );

      await authProvider.register(profileData);

    } catch (e) {
      authProvider.setError(e.toString()); // Set error state
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
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
    return Scaffold(
       appBar: AppBar(title: const Text("Complete Your Profile"), automaticallyImplyLeading: false),
       body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(25),
              children: [
                 Text("First Name", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                 CTextField(controller: _firstNameController, hintText: "Enter your first name", validator: (val) => val == null || val.isEmpty ? 'First name is required' : null,),
                 const SizedBox(height: 15,),
                 
                 Text("Last Name", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                 CTextField(controller: _lastNameController, hintText: "Enter your last name", validator: (val) => val == null || val.isEmpty ? 'Last name is required' : null,),
                 const SizedBox(height: 15,),

                 Text("Date Of Birth", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                 CTextField(controller: _dobController, hintText: "YYYY-MM-DD"),
                 const SizedBox(height: 30,),

                 // Image upload buttons would be here

                 const SizedBox(height: 30,),

                if (authProvider.errorMessage != null && authProvider.authStatus != AuthStatus.Authenticating)
                  Container(
                     padding: const EdgeInsets.all(12),
                     margin: const EdgeInsets.only(bottom: 20),
                     // ... error container styling
                  ),

                 MaterialButton(
                   onPressed: authProvider.authStatus == AuthStatus.Authenticating ? null : _registerProfile,
                   child: Container(
                     height: 60,
                     alignment: Alignment.center,
                     decoration: BoxDecoration(color: theme.colorScheme.primary, borderRadius: BorderRadius.circular(25)),
                     child: authProvider.authStatus == AuthStatus.Authenticating
                         ? const CircularProgressIndicator(color: Colors.white)
                         : Text("Register", style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.onPrimary)),
                   ),
                 ),
              ],
            ),
          );
        },
       ),
    );
  }
}
