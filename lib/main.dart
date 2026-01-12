import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:sakani/providers/admin_provider.dart';
import 'package:sakani/providers/apartment_provider.dart';
import 'package:sakani/providers/booking_provider.dart';
import 'package:sakani/providers/locale_provider.dart';
import 'package:sakani/providers/review_provider.dart';
import 'package:sakani/providers/theme_provider.dart';
import 'package:sakani/providers/user_provider.dart';
import 'package:sakani/screens/auth/auth_gate.dart';
import 'package:sakani/theme/app_theme.dart';

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
            // CORRECTED: Apply the bilingual font to both themes
            theme: AppTheme.lightTheme.copyWith(
              textTheme: AppTheme.lightTheme.textTheme.apply(fontFamily: 'Cairo'),
            ),
            darkTheme: AppTheme.darkTheme.copyWith(
              textTheme: AppTheme.darkTheme.textTheme.apply(fontFamily: 'Cairo'),
            ),
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
