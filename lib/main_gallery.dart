import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/providers/review_provider.dart';
import 'package:plproject/providers/theme_provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/dev/screen_gallery.dart';
import 'package:plproject/theme/app_theme.dart';

// Main entry point for the UI testbed environment
void main() {
  runApp(const ScreenGalleryApp());
}

class ScreenGalleryApp extends StatelessWidget {
  const ScreenGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    // A robust MultiProvider setup that mimics the main application.
    // This ensures that all screens have access to the providers they need.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        // ProxyProviders ensure that dependent providers get updated when UserProvider changes.
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
            title: 'Screen Gallery',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            home: const ScreenGallery(),
          );
        },
      ),
    );
  }
}
