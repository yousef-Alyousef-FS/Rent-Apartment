import 'package:flutter/material.dart';
import 'package:plproject/screens/auth/complete_profile.dart';
import 'package:plproject/widgets/CTextField.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const SizedBox(height: 50,),
          Image.asset("images/logo.png", width: 175, height: 175,),
          const SizedBox(height: 50,),
          Text("Register", style: theme.textTheme.displayMedium,),
          SizedBox(height: 50, child: Text("Fill your data to continue using the app...", style: theme.textTheme.bodyMedium,)),
          Text("Phone number", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
          CTextField(hintText: "Enter your phone number", maxLength: 10,),
          const SizedBox(height: 25,),
          Text("Create password", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
          CTextField(hintText: "Enter password with 8 characters", maxLength: 8, isPassword: true,),
          const SizedBox(height: 25,),
          Text("Confirm password", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
          CTextField(hintText: "Enter password with 8 characters", maxLength: 8, isPassword: true,),
          const SizedBox(height: 100,),
          MaterialButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CompleteProfile()),
              );
            },
            padding: const EdgeInsets.symmetric(horizontal: 80),
            child: Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary, // Use theme color
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
              child: Text(
                "Register",
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onPrimary, // Use text color for on primary
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account? ", style: theme.textTheme.bodyMedium,),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Go back to the login screen
                },
                child: Text(
                  "Login",
                  style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
