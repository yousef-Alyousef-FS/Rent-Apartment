import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/auth_provider.dart';
import 'package:plproject/screens/auth/forgot_password_screen.dart';
import 'package:plproject/screens/auth/register.dart';
import 'package:plproject/utils/validators.dart';
import 'package:plproject/widgets/CTextField.dart';
import 'package:plproject/theme/app_theme.dart';

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
    if (_formKey.currentState?.validate() ?? false) {
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
                Image.asset("assets/images/logo.png", width: 175, height: 175,),
                const SizedBox(height: 50,),
                Text("Login", style: theme.textTheme.displayMedium,),
                SizedBox(height: 50, child: Text("Login to continue using the app...", style: theme.textTheme.bodyMedium,)),
                
                Text("Phone number", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
                CTextField(controller: _phoneController, hintText: "Enter your phone number", validator: (val) => Validators.hasMinLength(val, 10), textInputType: TextInputType.phone, maxLength: 10,),
                const SizedBox(height: 25,),
                
                Text("Password", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
                CTextField(controller: _passwordController, hintText: "Enter your password", isPassword: true, maxLength: 10, validator: (val) => Validators.hasMinLength(val, 4),),
                
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                    },
                    child: const Text("Forgot your password?"),
                  ),
                ),

                const SizedBox(height: 20,),

                if (authProvider.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: theme.colorScheme.error.withOpacity(0.3), width: 1),
                    ),
                    child: Text(
                      authProvider.errorMessage!,
                      style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),

                MaterialButton(
                  onPressed: authProvider.authStatus == AuthStatus.Authenticating ? null : _login,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  child: Ink(
                    decoration: BoxDecoration(gradient: AppTheme.primaryGradient, borderRadius: BorderRadius.circular(25)),
                    child: Container(
                      height: 60,
                      alignment: Alignment.center,
                      child: authProvider.authStatus == AuthStatus.Authenticating
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text("Login", style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white)),
                    ),
                  ),
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
