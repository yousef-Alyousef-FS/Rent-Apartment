import 'package:flutter/material.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/providers/review_provider.dart';
import 'package:plproject/providers/theme_provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/main/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/theme/app_theme.dart';

// This is the entry point for running a specific widget in a test environment.
void main() {
  runApp(const UITestbedApp());
}

class UITestbedApp extends StatelessWidget {
  const UITestbedApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use MultiProvider to provide all necessary providers for the screen under test.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<UserProvider, ApartmentProvider>(
          create: (_) => ApartmentProvider(),
          update: (_, userProvider, apartmentProvider) =>
              apartmentProvider!..update(userProvider),
        ),
        ChangeNotifierProxyProvider<UserProvider, BookingProvider>(
          create: (_) => BookingProvider(),
          update: (_, userProvider, bookingProvider) =>
              bookingProvider!..update(userProvider),
        ),
        ChangeNotifierProxyProvider<UserProvider, ReviewProvider>(
          create: (_) => ReviewProvider(),
          update: (_, userProvider, reviewProvider) =>
              reviewProvider!..update(userProvider),
        ),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "UI Testbed",
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            // Directly display the screen you want to test.
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
