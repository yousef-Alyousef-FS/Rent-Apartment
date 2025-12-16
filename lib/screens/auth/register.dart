import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/auth_provider.dart';
import 'package:plproject/utils/validators.dart';
import 'package:plproject/widgets/CTextField.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.register(_phoneController.text, _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(25),
              children: [
                Image.asset("images/logo.png", width: 150, height: 150,),
                const SizedBox(height: 20,),
                Text("Create Account", style: theme.textTheme.displayMedium, textAlign: TextAlign.center,),
                SizedBox(height: 30, child: Text("Let's get you started!", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center,)),
                
                Text("Phone number", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
                CTextField(
                  controller: _phoneController,
                  hintText: "Enter your phone number",
                  maxLength: 10,
                  textInputType: TextInputType.phone,
                  validator: Validators.isNotEmpty,
                ),
                const SizedBox(height: 20,),
                
                Text("Create password", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
                CTextField(
                  controller: _passwordController,
                  hintText: "Enter password with 8 characters",
                  maxLength: 8,
                  isPassword: true,
                  validator: (value) => Validators.hasMinLength(value, 8),
                ),
                const SizedBox(height: 20,),
                
                Text("Confirm password", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),),
                CTextField(
                  controller: _confirmPasswordController,
                  hintText: "Re-enter your password",
                  maxLength: 8,
                  isPassword: true,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Passwords do not match!';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 50,),
                MaterialButton(
                  onPressed: authProvider.authStatus == AuthStatus.Authenticating ? null : _register,
                  child: Container(
                    height: 60,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: authProvider.authStatus == AuthStatus.Authenticating
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("Register", style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.onPrimary)),
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
                    Text("Already have an account? ", style: theme.textTheme.bodyMedium,),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text("Login", style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
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
