import 'package:flutter/material.dart';
import 'package:plproject/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/auth_provider.dart';
import 'package:plproject/screens/auth/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => ApartmentProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Rent Apartments",
        theme: AppTheme.lightTheme, // Re-enabled the theme
        home: const AuthWrapper(),
      ),
    );
  }
}
