import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/auth/auth_gate.dart';
import 'package:plproject/screens/auth/forgot_password_screen.dart';
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

  Future<void> _login(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final success = await userProvider.login(
      _phoneController.text,
      _passwordController.text,
    );

    if (success && mounted) {
      // The most robust solution: Navigate back to the AuthGate.
      // This tells the app to re-evaluate the authentication state from the root.
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthGate()),
        (route) => false,
      );
    }
    // If login fails, the Consumer below will automatically show the error message.
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
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
                    style: ElevatedButton.styleFrom(
                      textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    onPressed: userProvider.status == UserStatus.Loading ? null : () => _login(context),
                    child: userProvider.status == UserStatus.Loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Login'),
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
