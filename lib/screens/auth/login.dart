import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/auth_provider.dart';
import 'package:plproject/screens/auth/register.dart';
import 'package:plproject/utils/validators.dart';
import 'package:plproject/widgets/CTextField.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // First, validate the form.
    if (_formKey.currentState?.validate() ?? false) {
      // If the form is valid, call the login method.
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.login(_phoneController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(25),
              children: [
                const SizedBox(height: 50,),
                Image.asset("images/logo.png", width: 175, height: 175,),
                const SizedBox(height: 50,),
                Text("Login", style: theme.textTheme.displayMedium,),
                SizedBox(height: 50, child: Text("Login to continue using the app...", style: theme.textTheme.bodyMedium,)),
                
                Text("Phone number", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
                CTextField(
                  controller: _phoneController,
                  hintText: "Enter your phone number",
                  maxLength: 10,
                  textInputType: TextInputType.phone,
                  validator: Validators.isNotEmpty,
                ),
                const SizedBox(height: 25,),
                
                Text("Password", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
                CTextField(
                  controller: _passwordController,
                  hintText: "Enter your password",
                  isPassword: true,
                  maxLength: 8,
                  validator: (value) => Validators.hasMinLength(value, 8),
                ),
                const SizedBox(height: 80,),
                
                MaterialButton(
                  onPressed: authProvider.authStatus == AuthStatus.Authenticating ? null : _login,
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: authProvider.authStatus == AuthStatus.Authenticating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("Login", style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.onPrimary)),
                  ),
                ),
                
                if (authProvider.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(authProvider.errorMessage!, style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ", style: theme.textTheme.bodyMedium,),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                      child: Text("Register", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
