import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// --- CORRECTED: The one true, standard path ---


import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/providers/theme_provider.dart';
import 'package:plproject/providers/locale_provider.dart';
import 'package:plproject/providers/review_provider.dart';
import 'package:plproject/screens/auth/auth_gate.dart';
import 'package:plproject/theme/app_theme.dart';

import 'generated/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProxyProvider<UserProvider, ApartmentProvider>(
          create: (_) => ApartmentProvider(),
          update: (_, user, apartment) => apartment!..update(user),
        ),
        ChangeNotifierProxyProvider<UserProvider, BookingProvider>(
          create: (_) => BookingProvider(),
          update: (_, user, booking) => booking!..update(user),
        ),
        ChangeNotifierProxyProvider<UserProvider, ReviewProvider>(
          create: (_) => ReviewProvider(),
          update: (_, user, review) => review!..update(user),
        ),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, child) {
          return MaterialApp(
            title: 'PL-Project',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            debugShowCheckedModeBanner: false,
            
            locale: localeProvider.locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('ar', ''),
            ],

            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
