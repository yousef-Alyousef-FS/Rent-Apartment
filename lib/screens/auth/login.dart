import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:plproject/generated/app_localizations.dart'; // Import localizations
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/auth/auth_gate.dart';
import 'package:plproject/screens/auth/forgot_password_screen.dart';
import 'package:plproject/screens/auth/register.dart';
import 'package:plproject/utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  // --- NEW: State for password visibility ---
  bool _obscurePassword = true;

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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthGate()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(25),
              children: [
                const SizedBox(height: 50),
                Image.asset("assets/images/logo.png", width: 175, height: 175),
                const SizedBox(height: 50),
                Text(loc.loginTitle, style: theme.textTheme.displayMedium),
                SizedBox(height: 50, child: Text(loc.loginSubtitle, style: theme.textTheme.bodyMedium)),
                
                Text(loc.phoneNumber, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (val) => Validators.hasMinLength(val, 10),
                  maxLength: 10,
                  decoration: InputDecoration(hintText: loc.enterPhoneNumber, counterText: ""),
                ),
                const SizedBox(height: 25),
                
                Text(loc.password, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  validator: (val) => Validators.hasMinLength(val, 4),
                  maxLength: 20,
                  // --- UPDATED: Added visibility toggle ---
                  decoration: InputDecoration(
                    hintText: loc.enterPassword,
                    counterText: "",
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()));
                    },
                    child: Text(loc.forgotYourPassword),
                  ),
                ),

                const SizedBox(height: 20),

                if (userProvider.status == UserStatus.Error && userProvider.errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: theme.colorScheme.error.withOpacity(0.3), width: 1),
                    ),
                    child: Text(userProvider.errorMessage!, style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
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
                        : Text(loc.login),
                  ),
                ),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(loc.dontHaveAnAccount, style: theme.textTheme.bodyMedium),
                    GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterPage())),
                      child: Text(loc.register, style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
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
