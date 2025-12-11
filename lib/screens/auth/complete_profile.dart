import 'package:flutter/material.dart';
import 'package:plproject/screens/appartments/appartment.dart';
import '../../widgets/CTextField.dart';

class CompleteProfile extends StatelessWidget {
  const CompleteProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Complete Profile"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Center(
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  width: 4,
                ),
              ),
              child: Icon(Icons.person_rounded, size: 150, color: theme.colorScheme.onSurface.withOpacity(0.4),),
            ),
          ),
          const SizedBox(height: 10,),
          Text("Personal Information", style: theme.textTheme.displaySmall, textAlign: TextAlign.center,),
          const SizedBox(height: 10,),
          Text("Fill your information to continue...", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center,),
          const SizedBox(height: 20,),
          Text("First Name", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
          CTextField(hintText: "Enter your first name", maxLength: 20,),
          const SizedBox(height: 10,),
          Text("Last Name", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
          CTextField(hintText: "Enter your last name", maxLength: 20,),
          const SizedBox(height: 10,),
          Text("Date Of Birth", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
          CTextField(hintText: "MM/DD/YYYY",),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildUploadButton(theme, icon: Icons.camera_alt_outlined, label: "Upload\nPersonal Image"),
              _buildUploadButton(theme, icon: Icons.credit_card_outlined, label: "Upload Id\nCard Image"),
            ],
          ),
          const SizedBox(height: 30,),
          MaterialButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Apartments()),
                (Route<dynamic> route) => false,
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Text(
                "Submit",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(ThemeData theme, {required IconData icon, required String label}) {
    return Column(
      children: [
        MaterialButton(
          height: 90,
          onPressed: () {},
          child: Container(
            width: 120, // give a width
            height: 90,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(icon, color: theme.colorScheme.onPrimary, size: 50,),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
      ],
    );
  }
}
