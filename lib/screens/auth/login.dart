import 'package:flutter/material.dart';
import 'package:plproject/screens/auth/register.dart';
import 'package:plproject/widgets/CTextField.dart';
import '../appartments/appartment.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
          Text("Login", style: theme.textTheme.displayMedium,),
          SizedBox(height: 75, child: Text("Login to continue using the app...", style: theme.textTheme.bodyMedium,)),
          Text("Phone number", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
          CTextField(hintText: "Enter your phone number", maxLength: 10,),
          const SizedBox(height: 25,),
          Text("Password", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
          CTextField(hintText: "Enter your password", isPassword: true, maxLength: 8,),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            height: 80,
            alignment: Alignment.topRight,
            child: Text("Forgot your password?", style: TextStyle(color: theme.colorScheme.primary),),
          ),
          const SizedBox(height: 80,),
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
                color: theme.colorScheme.primary, // Use theme color
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
              child: Text(
                "Login",
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
              Text("Don't have an account? ", style: theme.textTheme.bodyMedium,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RegisterPage()),
                  );
                },
                child: Text(
                  "Register",
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
