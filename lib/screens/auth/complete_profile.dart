import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/user_provider.dart';
import '../../widgets/CTextField.dart';
import '../../theme/app_theme.dart';

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
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    await userProvider.register(
      phone: widget.phone,
      password: widget.password,
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      dateOfBirth: DateTime.tryParse(_dobController.text),
      personalImage: _personalImageFile,
      idCardImage: _idCardImageFile,
    );
    // No navigation here! AuthGate will handle it after the state changes.
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
       body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
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
                 CTextField(controller: _dobController, hintText: "YYYY-MM-DD", textInputType: TextInputType.datetime),
                 const SizedBox(height: 30,),

                 _buildImagePicker(theme, 'Personal Photo', _personalImageFile, () => _pickImage(true)),
                 const SizedBox(height: 20),
                 _buildImagePicker(theme, 'ID Card Photo', _idCardImageFile, () => _pickImage(false)),
                 const SizedBox(height: 30,),

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

                 MaterialButton(
                   onPressed: userProvider.status == UserStatus.Loading ? null : () => _registerProfile(context),
                   padding: EdgeInsets.zero,
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                   child: Ink(
                      decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(25)),
                      child: Container(
                         height: 60,
                         alignment: Alignment.center,
                         child: userProvider.status == UserStatus.Loading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text("Register", style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white)),
                      ),
                   ),
                 ),
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
                    child: Image.file(File(file.path), fit: BoxFit.cover, width: double.infinity)
                  ),
          ),
        ),
      ],
    );
  }
}
