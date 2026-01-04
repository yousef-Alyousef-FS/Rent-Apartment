import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/generated/app_localizations.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/utils/validators.dart';


class ForgotPasswordScreen extends StatefulWidget
{
    const ForgotPasswordScreen({super.key});

    @override
    State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
{
    final _formKey = GlobalKey<FormState>();
    final _phoneController = TextEditingController();
    bool _isLoading = false;

    Future<void> _sendResetRequest() async
    {
        if (!(_formKey.currentState?.validate() ?? false)) return;

        setState(() => _isLoading = true);

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final success = await userProvider.requestPasswordReset(_phoneController.text);

        // After the await, check if the widget is still in the tree
        if (!mounted) return;

        final loc = AppLocalizations.of(context)!;
        final theme = Theme.of(context);

        if (success)
        {
            // In a real scenario, this would show a success message.
            // For now, our mocked function always fails, so this part won't be reached.
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Instructions sent successfully!'), backgroundColor: Colors.green)
            );
        }
        else
        {
            // The provider will have an error message because our mocked function throws one.
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(userProvider.errorMessage ?? 'An unknown error occurred.'), backgroundColor: theme.colorScheme.error)
            );
        }

        setState(() => _isLoading = false);
    }

    @override
    void dispose()
    {
        _phoneController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context)
    {
        final theme = Theme.of(context);
        final loc = AppLocalizations.of(context)!;

        return Scaffold(
            appBar: AppBar(title: Text(loc.forgotPassword)),
            body: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                            const SizedBox(height: 20),
                            Text(
                                loc.resetYourPassword,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.headlineMedium
                            ),
                            const SizedBox(height: 16),
                            Text(
                                loc.forgotPasswordInstructions,
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium
                            ),
                            const SizedBox(height: 32),
                            Text(loc.phoneNumber, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                            const SizedBox(height: 8),
                            TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (val) => Validators.hasMinLength(val, 10),
                                decoration: InputDecoration(
                                    hintText: loc.enterPhoneNumber,
                                    counterText: ""
                                )
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                                onPressed: _isLoading ? null : _sendResetRequest,
                                child: _isLoading
                                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
                                    : Text(loc.sendResetInstructions)
                            )
                        ]
                    )
                )
            )
        );
    }
}
