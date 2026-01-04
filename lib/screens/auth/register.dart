import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/generated/app_localizations.dart'; // Import localizations
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/auth/complete_profile.dart';
import 'package:plproject/utils/validators.dart';

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

  // --- NEW: State for password visibility ---
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _proceedToNextStep(BuildContext context) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final navigator = Navigator.of(context);
    final isAvailable = await userProvider.checkPhoneAndNavigate(_phoneController.text);

    if (!mounted) return;

    if (isAvailable) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) => CompleteProfile(
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          return Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(25),
              children: [
                Image.asset("assets/images/logo.png", width: 150, height: 150),
                const SizedBox(height: 20),
                Text(loc.register, style: theme.textTheme.displayMedium, textAlign: TextAlign.center),
                // You can add a key like "getYouStarted" for this subtitle
                SizedBox(height: 30, child: Text("Let's get you started!", style: theme.textTheme.bodyMedium, textAlign: TextAlign.center)),
                
                Text(loc.phoneNumber, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  validator: Validators.isNotEmpty,
                  decoration: InputDecoration(hintText: loc.enterPhoneNumber, counterText: ""),
                ),
                const SizedBox(height: 20),
                
                // You can add a key like "createPassword" for this
                Text("Create password", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  maxLength: 20,
                  validator: (value) => Validators.hasMinLength(value, 8),
                  decoration: InputDecoration(
                    hintText: loc.enterPassword,
                    counterText: "",
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // You can add a key like "confirmPassword" for this
                Text("Confirm password", style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  maxLength: 20,
                  validator: (value) {
                    if (value != _passwordController.text) {
                      // You will need a key for "Passwords do not match!"
                      return 'Passwords do not match!'; 
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    // You will need a key for "Re-enter your password"
                    hintText: "Re-enter your password", 
                    counterText: "",
                    suffixIcon: IconButton(
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),
                ),
                const SizedBox(height: 50),

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
                    onPressed: userProvider.status == UserStatus.Loading ? null : () => _proceedToNextStep(context),
                    child: userProvider.status == UserStatus.Loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Next'), // You will need a key for "Next"
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
